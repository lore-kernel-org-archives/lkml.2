Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1HWCF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 22:05:59 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51487 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1HWCF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 22:05:57 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: separate priority boosting from REQ_META
References: <4E4E6238.3080808@fusionio.com>
	<20110820174137.GA27243@infradead.org> <4E5146C1.508@fusionio.com>
	<20110821181935.GA28979@infradead.org> <4E515057.7040802@fusionio.com>
	<20110822165221.GB7257@infradead.org>
Date: Tue, 23 Aug 2011 11:05:48 +0900
In-Reply-To: <20110822165221.GB7257@infradead.org> (Christoph Hellwig's
	message of "Mon, 22 Aug 2011 12:52:21 -0400")
Message-ID: <87r54cg9vn.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


Christoph Hellwig <hch@infradead.org> writes:
> Add a new REQ_PRIO to let requests preempt others in the cfq I/O schedule,
> and lave REQ_META purely for marking requests as metadata in blktrace.
>
> All existing callers of REQ_META except for XFS are updated to also
> set REQ_PRIO for now.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>

snipped...

> Index: linux-2.6/include/linux/blk_types.h
> ===================================================================
> --- linux-2.6.orig/include/linux/blk_types.h	2011-08-22 04:25:50.373473791 +0200
> +++ linux-2.6/include/linux/blk_types.h	2011-08-22 04:26:44.443473870 +0200
> @@ -124,6 +124,7 @@ enum rq_flag_bits {
>  
>  	__REQ_SYNC,		/* request is sync (sync write or read) */
>  	__REQ_META,		/* metadata io request */
> +	__REQ_PRIO,

It'd be better if it's commented too, IMHO.


>  	__REQ_DISCARD,		/* request to discard sectors */
>  	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
>  
> @@ -161,13 +162,14 @@ enum rq_flag_bits {
>  #define REQ_FAILFAST_DRIVER	(1 << __REQ_FAILFAST_DRIVER)
>  #define REQ_SYNC		(1 << __REQ_SYNC)
>  #define REQ_META		(1 << __REQ_META)
> +#define REQ_PRIO		(1 << __REQ_PRIO)
>  #define REQ_DISCARD		(1 << __REQ_DISCARD)
>  #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
>  
>  #define REQ_FAILFAST_MASK \
>  	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
>  #define REQ_COMMON_MASK \
> -	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
> +	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_PRIO | REQ_DISCARD | \
>  	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
>  #define REQ_CLONE_MASK		REQ_COMMON_MASK
>  

I think you need to include REQ_META into REQ_COMMON_MASK in order to
track those requests using blktrace.

Thanks.
