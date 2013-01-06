Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3AFWlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:41:04 -0500
Received: from mail-pb0-f66.google.com ([209.85.160.66]:51628 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3AFWlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:41:02 -0500
Date: Sun, 6 Jan 2013 14:37:29 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/power/da9052-battery.c: avoid out-of-range array
 access
Message-ID: <20130106223728.GA19097@lizard.sbx05280.losalca.wayport.net>
References: <1357413291-42105-1-git-send-email-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357413291-42105-1-git-send-email-nickolai@csail.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 02:14:51PM -0500, Nickolai Zeldovich wrote:
> Avoid accessing vc_tbl_ref[3], which is one past the end of that array,
> in da9052_determine_vc_tbl_index(), by adjusting the loop bound.
> 
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---

Applied, thanks!

>  drivers/power/da9052-battery.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
> index 3c5c2e4..08193fe 100644
> --- a/drivers/power/da9052-battery.c
> +++ b/drivers/power/da9052-battery.c
> @@ -337,7 +337,7 @@ static unsigned char da9052_determine_vc_tbl_index(unsigned char adc_temp)
>  	if (adc_temp > vc_tbl_ref[DA9052_VC_TBL_REF_SZ - 1])
>  		return DA9052_VC_TBL_REF_SZ - 1;
>  
> -	for (i = 0; i < DA9052_VC_TBL_REF_SZ; i++) {
> +	for (i = 0; i < DA9052_VC_TBL_REF_SZ - 1; i++) {
>  		if ((adc_temp > vc_tbl_ref[i]) &&
>  		    (adc_temp <= DA9052_MEAN(vc_tbl_ref[i], vc_tbl_ref[i + 1])))
>  				return i;
> -- 
> 1.7.10.4
