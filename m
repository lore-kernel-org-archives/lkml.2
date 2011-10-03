Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1JCGI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 02:08:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37853 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145Ab1JCGIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 02:08:50 -0400
Message-ID: <4E8951B7.7010106@ti.com>
Date: Mon, 3 Oct 2011 11:39:59 +0530
From: Archit Taneja <archit@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "JAIN, AMBER" <amber@ti.com>, "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH 20/30] media/omap_vout: disable driver for now
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-21-git-send-email-arnd@arndb.de>
In-Reply-To: <1317566760-25681-21-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> This driver was broken by 8cff88c5d "OMAP: DSS2: remove update_mode
> from omapdss":
>
> /home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c: In function 'omap_vout_probe':
> /home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2202:15: error: 'struct omap_dss_driver' has no member
> named 'set_update_mode'
> /home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2203:12: error: 'struct omap_dss_driver' has no member
> named 'set_update_mode'
> /home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2204:8: error: 'OMAP_DSS_UPDATE_MANUAL' undeclared (first
> use in this function)
> /home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2204:8: note: each undeclared identifier is reported only
> once for each function it appears in
> /home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2206:15: error: 'struct omap_dss_driver' has no member
> named 'set_update_mode'
> /home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2207:12: error: 'struct omap_dss_driver' has no member
> named 'set_update_mode'
> /home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2208:8: error: 'OMAP_DSS_UPDATE_AUTO' undeclared (first use
> in this function)
> make[3]: *** [drivers/media/video/omap/omap_vout.o] Error 1
> make[2]: *** [drivers/media/video/omap] Error 2
> make[1]: *** [drivers/media/video/] Error 2
> make: *** [sub-make] Error 2

A fix for this is already in the master branch of Mauro's tree:

git://linuxtv.org/media_tree.git

with the commit id:

5ebbf72dc51bd3b481aa91fea37a7157da5fc548

I am guessing this would during the 3.2 merge window.

Regards,
Archit

>
> Let's disable it for now.
>
> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
> Cc: Mauro Carvalho Chehab<mchehab@infradead.org>
> Cc: Archit Taneja<archit@ti.com>
> Cc: Amber Jain<amber@ti.com>
> Cc: Vaibhav Hiremath<hvaibhav@ti.com>
> ---
>   drivers/media/video/omap/Kconfig |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/omap/Kconfig b/drivers/media/video/omap/Kconfig
> index 390ab09..ee21f36 100644
> --- a/drivers/media/video/omap/Kconfig
> +++ b/drivers/media/video/omap/Kconfig
> @@ -4,6 +4,7 @@ config VIDEO_OMAP2_VOUT_VRFB
>   config VIDEO_OMAP2_VOUT
>   	tristate "OMAP2/OMAP3 V4L2-Display driver"
>   	depends on ARCH_OMAP2 || ARCH_OMAP3
> +	depends on BROKEN # broken by 8cff88c5da "OMAP: DSS2: remove update_mode from omapdss"
>   	select VIDEOBUF_GEN
>   	select VIDEOBUF_DMA_CONTIG
>   	select OMAP2_DSS

