Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1B1GsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:48:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63776 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1B1GsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:48:11 -0500
Date: Mon, 28 Feb 2011 15:48:05 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 05/09] ARM: s3c2440: gta02: Fix regulator valid_modes_ops
In-reply-to: <1297043521-21903-5-git-send-email-lars@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <000c01cbd713$76b8bcc0$642a3640$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvGaltAoXSO8aJKTsWW+4uhqTbWrgQp9b1w
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
 <1297043521-21903-5-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> The REGULATOR_CHANGE_STATUS flag needs to be set on valid_ops_mask,
otherwise
> it
> a driver wont be able to turn the regulator on or off.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/arm/mach-s3c2440/mach-gta02.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2440/mach-gta02.c
b/arch/arm/mach-s3c2440/mach-
> gta02.c
> index 6629998..e57c4d8 100644
> --- a/arch/arm/mach-s3c2440/mach-gta02.c
> +++ b/arch/arm/mach-s3c2440/mach-gta02.c
> @@ -314,8 +314,8 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  				.min_uV = 2000000,
>  				.max_uV = 3300000,
>  				.valid_modes_mask = REGULATOR_MODE_NORMAL,
> -				.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
> -				.always_on = 1,
> +				.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
> +						REGULATOR_CHANGE_STATUS,
>  			},
>  		},
>  		[PCF50633_REGULATOR_LDO1] = {
> @@ -323,6 +323,7 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  				.min_uV = 3300000,
>  				.max_uV = 3300000,
>  				.valid_modes_mask = REGULATOR_MODE_NORMAL,
> +				.valid_ops_mask = REGULATOR_CHANGE_STATUS,
>  				.apply_uV = 1,
>  				.state_mem = {
>  					.enabled = 0,
> @@ -350,6 +351,7 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  				.min_uV = 3200000,
>  				.max_uV = 3200000,
>  				.valid_modes_mask = REGULATOR_MODE_NORMAL,
> +				.valid_ops_mask = REGULATOR_CHANGE_STATUS,
>  				.apply_uV = 1,
>  			},
>  		},
> @@ -358,6 +360,7 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  				.min_uV = 3000000,
>  				.max_uV = 3000000,
>  				.valid_modes_mask = REGULATOR_MODE_NORMAL,
> +				.valid_ops_mask = REGULATOR_CHANGE_STATUS,
>  				.apply_uV = 1,
>  				.state_mem = {
>  					.enabled = 1,
> --

Ok, will apply.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

