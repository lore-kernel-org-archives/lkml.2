Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2LQLji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:39:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab2LQLjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:39:35 -0500
Date: Mon, 17 Dec 2012 09:39:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Arvind R <arvino55@gmail.com>
Cc: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: [PATCH 3.7.0 2/9] i82975x_edac.c: fix layers initialisation
Message-ID: <20121217093913.7c66fa5e@redhat.com>
In-Reply-To: <CAA_L+UPsAGmRB_gEittUOag0Hu1565jbvfNGsROj9n0x41W21Q@mail.gmail.com>
References: <CAA_L+UPsAGmRB_gEittUOag0Hu1565jbvfNGsROj9n0x41W21Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arvin,

Em Sun, 16 Dec 2012 02:09:46 +0530
Arvind R <arvino55@gmail.com> escreveu:

> Subject: [PATCH 3.7.0 2/9] i82975x_edac.c: fix layers initialisation
> 
> correct the absolutely wrong initialisation of memory layout.
> Signed-off-by: Arvind R. <arvino55@gmail.com>

This patch looks ok for me.

I didn't have time yet to test this patch series. My plan is to test it
after the merge window, likely in the beginning of January.

If you prefer, I can then merge this changeset (after being fixed with
the relevant comments that developers may point to you) on my linux-edac
tree, with my tested-by.

Regards,
Mauro


> ---
>  i82975x_edac.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/edac/i82975x_edac.c	2012-12-15 16:17:28 +0530
> +++ b/drivers/edac/i82975x_edac.c	2012-12-15 16:16:51 +0530
> @@ -544,10 +544,10 @@ static int i82975x_probe1(struct pci_dev
> 
>  	/* assuming only one controller, index thus is 0 */
>  	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
> -	layers[0].size = I82975X_NR_DIMMS;
> +	layers[0].size = I82975X_NR_CSROWS(chans);
>  	layers[0].is_virt_csrow = true;
>  	layers[1].type = EDAC_MC_LAYER_CHANNEL;
> -	layers[1].size = I82975X_NR_CSROWS(chans);
> +	layers[1].size = chans;
>  	layers[1].is_virt_csrow = false;
>  	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(*pvt));
>  	if (!mci) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
