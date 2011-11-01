Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1KAPGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 11:06:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab1KAPGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 11:06:22 -0400
Date: Tue, 1 Nov 2011 16:05:55 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: only initiate writeback for specified range
 with FADV_DONTNEED
Message-ID: <20111101150555.GC19965@redhat.com>
References: <1320077819-1494-1-git-send-email-sbohrer@rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320077819-1494-1-git-send-email-sbohrer@rgmadvisors.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 11:16:59AM -0500, Shawn Bohrer wrote:
> Previously POSIX_FADV_DONTNEED would start writeback for the entire file
> when the bdi was not write congested.  This negatively impacts
> performance if the file contians dirty pages outside of the requested
> range.  This change uses __filemap_fdatawrite_range() to only initiate
> writeback for the requested range.
> 
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>

It probably makes sense for some cases to take advantage of the disk
head being nearby and flush more than requested.

But I can certainly see this go wrong by taking away the write-caching
benefits for the rest of the file just because a small part of it was
fadvised.

Acked-by: Johannes Weiner <jweiner@redhat.com>
