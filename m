Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab1F1Gmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:42:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261Ab1F1GkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:40:25 -0400
Date: Tue, 28 Jun 2011 16:40:14 +1000
From: NeilBrown <neilb@suse.de>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid5: fix possible NULL pointer dereference in
 debug routine
Message-ID: <20110628164014.4a916b68@notabene.brown>
In-Reply-To: <1308891840-5683-1-git-send-email-namhyung@gmail.com>
References: <1308891840-5683-1-git-send-email-namhyung@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 14:04:00 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> When I ran dynamic debug, I encountered a NULL pointer dereference
> bug in add_stripe_bio(). Prior to second call to pr_debug(), @bi
> was reused in order to check whether the request is partial write
> or not, and it could lead to set @bi to NULL.
> 
> Since we save original @bi pointer into local variable 'bip', use
> it instead of NULL-able @bi.
> 
> Also changed confusing 'bh' to 'bi' in the first message.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/raid5.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 82c07fb38961..c814a6075c79 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2139,7 +2139,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
>  	raid5_conf_t *conf = sh->raid_conf;
>  	int firstwrite=0;
>  
> -	pr_debug("adding bh b#%llu to stripe s#%llu\n",
> +	pr_debug("adding bi b#%llu to stripe s#%llu\n",
>  		(unsigned long long)bi->bi_sector,
>  		(unsigned long long)sh->sector);
>  
> @@ -2181,7 +2181,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
>  	spin_unlock_irq(&conf->device_lock);
>  
>  	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
> -		(unsigned long long)bi->bi_sector,
> +		(unsigned long long)(*bip)->bi_sector,
>  		(unsigned long long)sh->sector, dd_idx);
>  
>  	if (conf->mddev->bitmap && firstwrite) {


Applied, thanks.

NeilBrown
