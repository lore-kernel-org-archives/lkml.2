Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1JQOZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:25:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1JQOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:25:20 -0400
Date: Mon, 17 Oct 2011 16:22:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, s.nawrocki@samsung.com
Subject: Re: [PATCH v4 2/3] at91: add parameters for at91_add_device_isi
 function
In-Reply-To: <1318331020-22031-3-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1110171616150.18438@axis700.grange>
References: <1318331020-22031-1-git-send-email-josh.wu@atmel.com>
 <1318331020-22031-3-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:njm5bgpu45RS0JHOPDFm2VYJ4JyUOsgVRviTbnS4eyC
 Se3sJtrOSdGn42EcEEKjXeZYtFlBVZM2TdTwqiS95Dl92ttC/b
 UNS9eCw3+/1MmqcgIWadQ2v8/EwhZ41n7qUZxHznHSbKojVD3f
 Ri+NhZQOCAqUctGYd6/vEJiDk7yz7cowDhkSFNVOeXTQWwG0+e
 TbAI63uMR8Kgx3tkdbnU3+ZvqKh+KLVUIjRZK/9ch2MnFpS8fw
 8O+wfeDjVby5S57C1WRBIhV6TmXdKdDgWfYSXmB3Lcfpr/ZbHI
 xi+I93TKR5007dQizUX+bDU2yP0x6ednwSEclxkFQz6l88Zjfa
 6GI0nBD0bInlSKuFc2xM6ivhrj972LnS1BqI37yYWHhxIfapH2
 Idw6e/gMASOWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Josh Wu wrote:

> This patch add parameters for at91_add_device_isi function
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  arch/arm/mach-at91/at91sam9263_devices.c |   13 ++++++++++---
>  arch/arm/mach-at91/include/mach/board.h  |    4 +++-
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
> index a050f41..7990e8e 100644
> --- a/arch/arm/mach-at91/at91sam9263_devices.c
> +++ b/arch/arm/mach-at91/at91sam9263_devices.c
> @@ -885,7 +885,8 @@ static struct platform_device at91sam9263_isi_device = {
>  	.num_resources	= ARRAY_SIZE(isi_resources),
>  };
>  
> -void __init at91_add_device_isi(void)
> +void __init at91_add_device_isi(struct isi_platform_data * data,

Not sure if anything in CodingStyle prohibits this, but the rest of this 
file uses

static type fn(struct s *p)

i.e., without an extra space after the '*'. Would be better to keep that 
style.

> +		bool use_pck_as_mck)
>  {
>  	at91_set_A_periph(AT91_PIN_PE0, 0);	/* ISI_D0 */
>  	at91_set_A_periph(AT91_PIN_PE1, 0);	/* ISI_D1 */
> @@ -898,14 +899,20 @@ void __init at91_add_device_isi(void)
>  	at91_set_A_periph(AT91_PIN_PE8, 0);	/* ISI_PCK */
>  	at91_set_A_periph(AT91_PIN_PE9, 0);	/* ISI_HSYNC */
>  	at91_set_A_periph(AT91_PIN_PE10, 0);	/* ISI_VSYNC */
> -	at91_set_B_periph(AT91_PIN_PE11, 0);	/* ISI_MCK (PCK3) */
>  	at91_set_B_periph(AT91_PIN_PE12, 0);	/* ISI_PD8 */
>  	at91_set_B_periph(AT91_PIN_PE13, 0);	/* ISI_PD9 */
>  	at91_set_B_periph(AT91_PIN_PE14, 0);	/* ISI_PD10 */
>  	at91_set_B_periph(AT91_PIN_PE15, 0);	/* ISI_PD11 */
> +
> +	if (use_pck_as_mck) {
> +		at91_set_B_periph(AT91_PIN_PE11, 0);	/* ISI_MCK (PCK3) */
> +
> +		/* TODO: register the PCK for ISI_MCK and set its parent */



> +	}
>  }
>  #else
> -void __init at91_add_device_isi(void) {}
> +void __init at91_add_device_isi(struct isi_platform_data * data,

same - no extra space.

> +		int use_pck_as_mck) {}
>  #endif
>  
>  
> diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
> index ed544a0..731c449 100644
> --- a/arch/arm/mach-at91/include/mach/board.h
> +++ b/arch/arm/mach-at91/include/mach/board.h
> @@ -183,7 +183,9 @@ extern void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data);
>  extern void __init at91_add_device_ac97(struct ac97c_platform_data *data);
>  
>   /* ISI */
> -extern void __init at91_add_device_isi(void);
> +struct isi_platform_data;
> +extern void __init at91_add_device_isi(struct isi_platform_data *data,
> +		bool use_pck_as_mck);
>  
>   /* Touchscreen Controller */
>  struct at91_tsadcc_data {
> -- 
> 1.6.3.3

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
