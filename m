Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab1FNEM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 00:12:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab1FNEMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 00:12:54 -0400
Date: Tue, 14 Jun 2011 14:12:42 +1000
From: NeilBrown <neilb@suse.de>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] md/raid5: fix raid5_set_bi_hw_segments
Message-ID: <20110614141242.6d3750b2@notabene.brown>
In-Reply-To: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
References: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011 23:48:22 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> The @bio->bi_phys_segments consists of active stripes count in the
> lower 16 bits and processed stripes count in the upper 16 bits. So
> logical-OR operator should be bitwise one.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/raid5.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 346e69bfdab3..fa6ac70dc72f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -129,7 +129,7 @@ static inline int raid5_dec_bi_hw_segments(struct bio *bio)
>  
>  static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
>  {
> -	bio->bi_phys_segments = raid5_bi_phys_segments(bio) || (cnt << 16);
> +	bio->bi_phys_segments = raid5_bi_phys_segments(bio) | (cnt << 16);
>  }
>  
>  /* Find first data disk in a raid6 stripe */


Thanks for this and the other 2!!
I have added "Cc: stable@kernel.org" to the first two and applied them.  I
expect to send them off to Linus later today.

Thanks,
NeilBrown
