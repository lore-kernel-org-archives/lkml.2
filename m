Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2JaFXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:23:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40962 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab2JaFXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:23:20 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        "Porter, Matt" <mporter@ti.com>, "Dill, Russ" <russ.dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH] da8xx: Allow use by am33xx based devices
Thread-Topic: [PATCH] da8xx: Allow use by am33xx based devices
Thread-Index: AQHNtst6Rx118OokEEubqhCbxHb81pfS2xNQ
Date: Wed, 31 Oct 2012 05:23:09 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3E9E1129@DBDE01.ent.ti.com>
References: <1351698968-3965-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1351698968-3965-1-git-send-email-panto@antoniou-consulting.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 31, 2012 at 21:26:08, Pantelis Antoniou wrote:
> This driver can be used for AM33xx devices, like the popular beaglebone.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/video/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 9791d10..e7868d8 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -2202,7 +2202,7 @@ config FB_SH7760
>  
>  config FB_DA8XX
>  	tristate "DA8xx/OMAP-L1xx Framebuffer support"
> -	depends on FB && ARCH_DAVINCI_DA8XX
> +	depends on FB && (ARCH_DAVINCI_DA8XX || SOC_AM33XX)

Agreed this is present on da8xx and am33xx, but moving forward for
supporting DT, we should be avoiding these dependencies. So instead
change this to remove machine dependencies.

Thanks,
Prakash

>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

