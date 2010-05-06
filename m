Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab0EFFl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 01:41:59 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:49800 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0EFFl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 01:41:58 -0400
Message-ID: <20100506074155.21054qc65d3dfm2o@webmail.df.eu>
Date: Thu, 06 May 2010 07:41:55 +0200
From: peter@piie.net
To: Rahul Chaturvedi <rkc@chromium.org>
Cc: linux-kernel@vger.kernel.org, msb@chromium.org
Subject: Re: [PATCH] CHROMIUM: acerhdf: fix bug when running on Qemu
References: <1273122377-12137-1-git-send-email-rkc@chromium.org>
In-Reply-To: <1273122377-12137-1-git-send-email-rkc@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Originating-IP: 80.82.223.8
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Rahul Chaturvedi <rkc@chromium.org>:

> Driver didn't verify the pointers in which it got product information
> back from DMI; on QEMU one of the pointers came back null,
> which made the driver crash and subsequently caused a kernel panic.
>
> Signed-off-by: Rahul Chaturvedi <rkc@chromium.org>
> ---
>  drivers/platform/x86/acerhdf.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 4d922e4..e8ee3b2 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -500,6 +500,11 @@ static int acerhdf_check_hardware(void)
>  	product = dmi_get_system_info(DMI_PRODUCT_NAME);
>
>
> +	if (!vendor || !version || !product) {
> +		pr_err("error getting hardware information");
> +		return -EINVAL;
> +	}
> +
>  	pr_info("Acer Aspire One Fan driver, v.%s\n", DRV_VER);
>
>  	if (force_bios[0]) {
> --
> 1.7.0.1
>
>

Acked-by: Peter Feuerer <peter@piie.net>


