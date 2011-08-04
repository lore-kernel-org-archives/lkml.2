Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab1HDE0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 00:26:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1HDE0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 00:26:49 -0400
Date: Thu, 4 Aug 2011 14:26:39 +1000
From: NeilBrown <neilb@suse.de>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: use REQ_NOIDLE flag in md_super_write()
Message-ID: <20110804142639.6484de94@notabene.brown>
In-Reply-To: <1312387077-26617-1-git-send-email-namhyung@gmail.com>
References: <1312387077-26617-1-git-send-email-namhyung@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Aug 2011 00:57:57 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Queue idling is used for the anticipation of immediate
> sequencial I/O's but md_super_write() is a kind of one-
> shot operation, coupled with md_super_wait(), so the
> idling in this case will be just a waste of time.
> 
> Specifying REQ_NOIDLE prevents it. Instead of adding
> the flag to submit_bio() directly, use pre-defined
> macro WRITE_FLUSH_FUA.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/md.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d97a62534798..8650e9a0ce7c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -848,7 +848,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
>  	bio->bi_end_io = super_written;
>  
>  	atomic_inc(&mddev->pending_writes);
> -	submit_bio(REQ_WRITE | REQ_SYNC | REQ_FLUSH | REQ_FUA, bio);
> +	submit_bio(WRITE_FLUSH_FUA, bio);
>  }
>  
>  void md_super_wait(mddev_t *mddev)

Applied, thanks.

NeilBrown


