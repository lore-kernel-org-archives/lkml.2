Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab2JSSLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:11:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236Ab2JSSLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:11:14 -0400
Date: Fri, 19 Oct 2012 14:11:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk,
        martin.petersen@oracle.com
Subject: Re: [PATCH v4 2/2] block: Convert integrity to bvec_alloc_bs()
Message-ID: <20121019181103.GH27052@redhat.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <1350331769-14856-29-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350331769-14856-29-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 01:09:02PM -0700, Kent Overstreet wrote:
> This adds a pointer to the bvec array to struct bio_integrity_payload,
> instead of the bvecs always being inline; then the bvecs are allocated
> with bvec_alloc_bs().
> 
> Changed bvec_alloc_bs() and bvec_free_bs() to take a pointer to a
> mempool instead of the bioset, so that bio integrity can use a different
> mempool for its bvecs, and thus avoid a potential deadlock.
> 
> This is eventually for immutable bio vecs - immutable bvecs aren't
> useful if we still have to copy them, hence the need for the pointer.
> Less code is always nice too, though.

I think this patch should be part of your immutable prep work series or
later series. First patch is the stand alone fix for bio integrity for
bio_split() case. I would say post that separately and hopefully martin
likes it and acks it. It is simple enough and looks right to me though.

Thanks
Vivek
