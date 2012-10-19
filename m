Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab2JSUaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 16:30:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56533 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922Ab2JSUaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 16:30:20 -0400
Date: Fri, 19 Oct 2012 13:30:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, vgoyal@redhat.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH v4 1/2] block: Fix a buffer overrun in
 bio_integrity_split()
Message-ID: <20121019203015.GS13370@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <1350331769-14856-28-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350331769-14856-28-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 01:09:01PM -0700, Kent Overstreet wrote:
> bio_integrity_split() seemed to be confusing pointers and arrays -
> bip_vec in bio_integrity_payload was an array appended to the end of the
> payload, so the bio_vecs in struct bio_pair should have come after the
> bio_integrity_payload they're for.
> 
> Fix it by making bip_vec a pointer to the inline vecs - a later patch is
> going to make more use of this pointer.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Martin K. Petersen <martin.petersen@oracle.com>

This being an apparent bug, I think it would be better to create a
patch to simply reorder bio_pair fields to fix it and mark it w/ Cc:
stable and introduce bip_vec pointer separately.

Other than that, looks good.

Thanks.

-- 
tejun
