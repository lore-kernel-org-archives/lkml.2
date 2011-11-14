Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1KNXVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:21:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1KNXVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:21:01 -0500
Date: Mon, 14 Nov 2011 15:21:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Reduce the amount of work done when updating
 min_free_kbytes
Message-Id: <20111114152100.1333a015.akpm@linux-foundation.org>
In-Reply-To: <20111111162119.GP3083@suse.de>
References: <20111111162119.GP3083@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Nov 2011 16:21:19 +0000
Mel Gorman <mgorman@suse.de> wrote:

> When min_free_kbytes is updated, some pageblocks are marked MIGRATE_RESERVE.
> Ordinarily, this work is unnoticable as it happens early in boot but on
> large machines with 1TB of memory, this has been reported to delay
> boot times, probably due to the NUMA distances involved.
> 
> The bulk of the work is due to calling calling pageblock_is_reserved()
> an unnecessary amount of times and accessing far more struct page
> metadata than is necessary. This patch significantly reduces the
> amount of work done by setup_zone_migrate_reserve() improving boot
> times on 1TB machines.
> 

By how much? :)

(I mainly ask because I'm curious to know how long the kernel takes to
boot on a 1TB machine...)

