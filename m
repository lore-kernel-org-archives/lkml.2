Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab1JRAI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 20:08:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14478 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1JRAI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 20:08:58 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-3e-4e9cc3983a8c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Grant Likely'" <grant@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
References: <1318887379-5158-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1318887379-5158-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH v2] gpio/samsung: Complain loudly if we don't know the SoC
Date: Tue, 18 Oct 2011 09:08:55 +0900
Message-id: <00b601cc8d2a$20d20780$62761680$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyNFNdsQpV2r2R7RnSdEydP7QCPjwAFPIXw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> 
> If we don't know the SoC type then we won't add any chips which is rather
> unfortunate as neither GPIO nor pinmux APIs will work, breaking lots of
> different subsystems. Logging at least provides a hint to the user as to
> what's gone wrong.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/gpio/gpio-samsung.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index 479edc3..8662518 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -2486,6 +2486,9 @@ static __init int samsung_gpiolib_init(void)
>  		s5p_register_gpioint_bank(IRQ_GPIO_XA, 0,
> IRQ_GPIO1_NR_GROUPS);
>  		s5p_register_gpioint_bank(IRQ_GPIO_XB,
> IRQ_GPIO1_NR_GROUPS, IRQ_GPIO2_NR_GROUPS);
>  #endif
> +	} else {
> +		WARN(1, "Unknown SoC in gpio-samsung, no GPIOs added\n");
> +		return -ENODEV;
>  	}
> 
>  	return 0;
> --
> 1.7.6.3

Looks ok to me, applied.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

