Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab2IDNfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:35:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab2IDNfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:35:37 -0400
Date: Tue, 4 Sep 2012 09:35:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2] block/throttle: Add IO throttled information in
 blkio.throttle.
Message-ID: <20120904133528.GB13768@redhat.com>
References: <1346390109-3169-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346390109-3169-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 01:15:09PM +0800, Tao Ma wrote:

[..]
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 1588c2d..9317d71 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -46,6 +46,8 @@ struct tg_stats_cpu {
>  	struct blkg_rwstat		service_bytes;
>  	/* total IOs serviced, post merge */
>  	struct blkg_rwstat		serviced;
> +	/* total IOs queued, not submitted to the underlying device. */
> +	struct blkg_rwstat		io_queued;
>  };

Couple of questions.

- blkg_rwstat is "unsigned" and io_queued can go negative too (Because
  throttled bio can very well be dispatched from other cpu from a worker
  thread). So is it a good idea to represent a negative number with 
  unsingned type?

- As this stat is per cpu, a reader might very well see negative (or a
  huge unsigned value) as number of io_queued. Not sure if that is acceptable.
  How would user space come to know whether it is a valid value or not. I
  thought per cpu stats are good for continuously increasing values but
  not necessarily for values which can increase as well as decrease.

Thanks
Vivek
