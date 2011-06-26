Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1FZMYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 08:24:11 -0400
Received: from mail.hessware.de ([78.46.97.14]:56228 "EHLO mail.hessware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab1FZMYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 08:24:03 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jun 2011 08:24:02 EDT
From: Sebastian =?iso-8859-1?q?He=DF?= <shess@hessware.de>
Organization: Hessware
To: Constantine Shulyupin <const@makelinux.com>
Subject: Re: [PATCH] Enable USB on TI DM365
Date: Sun, 26 Jun 2011 14:11:17 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-ARCH; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        khilman@ti.com
References: <BANLkTims=UsUMkDQ8uB+J6YTVRSBD__otw@mail.gmail.com>
In-Reply-To: <BANLkTims=UsUMkDQ8uB+J6YTVRSBD__otw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106261411.17850.shess@hessware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 June 2011 20:51:31 Constantine Shulyupin wrote:

Hi,
 
> -void davinci_setup_usb(unsigned mA, unsigned potpgt_ms);
> +int davinci_setup_usb(unsigned mA, unsigned potpgt_ms);
> 
>  #endif	/* ifndef __ASM_ARCH_USB_H */
> diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
> index 23d2b6d..8b12206 100644
> --- a/arch/arm/mach-davinci/usb.c
> +++ b/arch/arm/mach-davinci/usb.c
> @@ -4,19 +4,22 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/dma-mapping.h>
> -
>  #include <linux/usb/musb.h>
> 
>  #include <mach/common.h>
>  #include <mach/irqs.h>
>  #include <mach/cputype.h>
>  #include <mach/usb.h>
> +#include <mach/mux.h>
> +#include <linux/gpio.h>
> 
>  #define DAVINCI_USB_OTG_BASE	0x01c64000
> 
>  #define DA8XX_USB0_BASE 	0x01e00000
>  #define DA8XX_USB1_BASE 	0x01e25000
> 
> +static int retval;
> +
Why do you add this as a global static var? As no locking is involved here 
this may cause problems as soon as we see SMP systems using this controller. 
Please put the variable into the functions needing it.

Best regards

Sebastian
-- 
Hessware - Open Source Solutions
