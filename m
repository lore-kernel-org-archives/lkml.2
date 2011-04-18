Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1DRPeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:34:00 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:57795 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755145Ab1DRPdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:33:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Lf0MEHLgaiMgiYZY5OoZhHkAXVLuLC8WedXcHc5WAk7YnJRhjNa91zFFT+gQhsubfZlmE0FFKIijesyd3FAyynlXI9r4esXQ/sIEiW5HdYxnFuLZ6gdU1GJDN456c/9M;
Message-ID: <4DAC59C7.1060807@tao.ma>
Date: Mon, 18 Apr 2011 23:33:27 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: jaxboe@fusionio.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add blk_run_queue_async
References: <20110418092647.GB3837@infradead.org>
In-Reply-To: <20110418092647.GB3837@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.48.16 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,
On 04/18/2011 05:26 PM, Christoph Hellwig wrote:
> Instead of overloading __blk_run_queue to force an offload to kblockd
> add a new blk_run_queue_async helper to do it explicitly.  I've kept
> the blk_queue_stopped check for now, but I suspect it's not needed
> as the check we do when the workqueue items runs should be enough.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

> Index: linux-2.6/block/blk.h
> ===================================================================
> --- linux-2.6.orig/block/blk.h	2011-04-18 10:53:39.001656864 +0200
> +++ linux-2.6/block/blk.h	2011-04-18 11:00:28.066107438 +0200
> @@ -22,6 +22,7 @@ void blk_rq_timed_out_timer(unsigned lon
>  void blk_delete_timer(struct request *);
>  void blk_add_timer(struct request *);
>  void __generic_unplug_device(struct request_queue *);
> +void blk_run_queue_async(struct request_queue *q);
any reason why this function isn't put together with the __blk_run_queue
below?
>  
>  /*
>   * Internal atomic flags for request handling
> Index: linux-2.6/include/linux/blkdev.h
> ===================================================================
> --- linux-2.6.orig/include/linux/blkdev.h	2011-04-18 10:48:11.170099546 +0200
> +++ linux-2.6/include/linux/blkdev.h	2011-04-18 10:58:41.003354113 +0200
> @@ -697,7 +697,7 @@ extern void blk_start_queue(struct reque
>  extern void blk_stop_queue(struct request_queue *q);
>  extern void blk_sync_queue(struct request_queue *q);
>  extern void __blk_stop_queue(struct request_queue *q);
> -extern void __blk_run_queue(struct request_queue *q, bool force_kblockd);
> +extern void __blk_run_queue(struct request_queue *q);
>  extern void blk_run_queue(struct request_queue *);
>  extern int blk_rq_map_user(struct request_queue *, struct request *,
>  			   struct rq_map_data *, void __user *, unsigned long,
Regards,
Tao
