Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1FBFsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:48:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:52513 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281Ab1FBFsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:48:13 -0400
Date: Thu, 2 Jun 2011 15:47:54 +1000
From: NeilBrown <neilb@suse.de>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] md: convert double atomic_inc() to atomic_add()
Message-ID: <20110602154754.142920c6@notabene.brown>
In-Reply-To: <1306990383-14133-1-git-send-email-namhyung@gmail.com>
References: <1306990383-14133-1-git-send-email-namhyung@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Jun 2011 13:53:02 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/md.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aa640a85bb21..f210e42a56ca 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -396,8 +396,7 @@ static void submit_flushes(struct work_struct *ws)
>  			 * we reclaim rcu_read_lock
>  			 */
>  			struct bio *bi;
> -			atomic_inc(&rdev->nr_pending);
> -			atomic_inc(&rdev->nr_pending);
> +			atomic_add(2, &rdev->nr_pending);
>  			rcu_read_unlock();
>  			bi = bio_alloc_mddev(GFP_KERNEL, 0, mddev);
>  			bi->bi_end_io = md_end_flush;

Thanks, but I don't think I want this patch.
I'm happy having two separate 'atomic_inc' calls. I think it makes it a bit
clearer what is happening, and it is easier to search for all atomic_inc
calls.

NeilBrown
