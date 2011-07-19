Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1GSFaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 01:30:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57917 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab1GSFaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 01:30:08 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Jon Povey'" <jon.povey@racelogic.co.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jul 2011 10:59:49 +0530
Subject: RE: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Topic: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Index: AcxFxEO6UigcFyPiSea2qTqvKwuHFAAD90Yg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF73E@dbde02.ent.ti.com>
References: <1311046211-2849-1-git-send-email-jon.povey@racelogic.co.uk>
In-Reply-To: <1311046211-2849-1-git-send-email-jon.povey@racelogic.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon,

The fix looks correct. As a part of a different implementation which will go soon upstream, this has been taken care of, where we have used macros 
CPLD_VIDEO_INPUT_MUX_TVP7002    0x1
CPLD_VIDEO_INPUT_MUX_IMAGER     0x2

So, if you can do the same, it will look better.

Thanks,
-Manju


On Tue, Jul 19, 2011 at 09:00:11, Jon Povey wrote:
> Video input mux settings for tvp7002 and imager inputs were swapped.
> Comment was correct.
> 
> Tested on EVM with tvp7002 input.
> 
> Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
> ---
> As a bugfix maybe this should try to get into 3.0?
> 
>  arch/arm/mach-davinci/board-dm365-evm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index c67f684..09a87e6 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -520,7 +520,7 @@ fail:
>  	 */
>  	if (have_imager()) {
>  		label = "HD imager";
> -		mux |= 1;
> +		mux |= 2;
>  
>  		/* externally mux MMC1/ENET/AIC33 to imager */
>  		mux |= BIT(6) | BIT(5) | BIT(3);
> @@ -540,7 +540,7 @@ fail:
>  		resets &= ~BIT(1);
>  
>  		if (have_tvp7002()) {
> -			mux |= 2;
> +			mux |= 1;
>  			resets &= ~BIT(2);
>  			label = "tvp7002 HD";
>  		} else {
> --
> 1.6.3.3
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 

