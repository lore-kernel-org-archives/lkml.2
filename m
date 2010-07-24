Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0GXChs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 22:37:48 -0400
Received: from relais.videotron.ca ([24.201.245.36]:36357 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0GXChr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 22:37:47 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_cxrjA1VFI76nC6Rzcd2wow)"
Date: Fri, 23 Jul 2010 22:37:43 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Russell King <linux@arm.linux.org.uk>,
        Martin Michlmayr <tbm@cyrius.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] ARM: kirkwood: move qnap_tsx1x_register_flash() to
 .init.text
In-reply-to: <1279915120-4373-2-git-send-email-u.kleine-koenig@pengutronix.de>
Message-id: <alpine.LFD.2.00.1007232236510.19477@xanadu.home>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1279915120-4373-2-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_cxrjA1VFI76nC6Rzcd2wow)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

On Fri, 23 Jul 2010, Uwe Kleine-König wrote:

> qnap_tsx1x_register_flash is only called by qnap_ts219_init and
> qnap_ts41x_init which both live in .init.text, too.  So the move is OK.
> 
> This fixes the following warning in kirkwood_defconfig:
> 	WARNING: vmlinux.o(.text+0x9334): Section mismatch in reference from the function qnap_tsx1x_register_flash() to the variable .init.data:qnap_tsx1x_spi_slave_info
> 	The function qnap_tsx1x_register_flash() references
> 	the variable __initdata qnap_tsx1x_spi_slave_info.
> 	This is often because qnap_tsx1x_register_flash lacks a __initdata
> 	annotation or the annotation of qnap_tsx1x_spi_slave_info is wrong.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

ACK.  You may send to RMK's patch system.



> ---
>  arch/arm/mach-kirkwood/tsx1x-common.c |    2 +-
>  arch/arm/mach-kirkwood/tsx1x-common.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-kirkwood/tsx1x-common.c b/arch/arm/mach-kirkwood/tsx1x-common.c
> index 7221c20..f781164 100644
> --- a/arch/arm/mach-kirkwood/tsx1x-common.c
> +++ b/arch/arm/mach-kirkwood/tsx1x-common.c
> @@ -77,7 +77,7 @@ struct spi_board_info __initdata qnap_tsx1x_spi_slave_info[] = {
>  	},
>  };
>  
> -void qnap_tsx1x_register_flash(void)
> +void __init qnap_tsx1x_register_flash(void)
>  {
>  	spi_register_board_info(qnap_tsx1x_spi_slave_info,
>  				ARRAY_SIZE(qnap_tsx1x_spi_slave_info));
> diff --git a/arch/arm/mach-kirkwood/tsx1x-common.h b/arch/arm/mach-kirkwood/tsx1x-common.h
> index 9a59296..7fa0373 100644
> --- a/arch/arm/mach-kirkwood/tsx1x-common.h
> +++ b/arch/arm/mach-kirkwood/tsx1x-common.h
> @@ -1,7 +1,7 @@
>  #ifndef __ARCH_KIRKWOOD_TSX1X_COMMON_H
>  #define __ARCH_KIRKWOOD_TSX1X_COMMON_H
>  
> -extern void qnap_tsx1x_register_flash(void);
> +extern void __init qnap_tsx1x_register_flash(void);
>  extern void qnap_tsx1x_power_off(void);
>  
>  #endif
> -- 
> 1.7.1
> 

--Boundary_(ID_cxrjA1VFI76nC6Rzcd2wow)--
