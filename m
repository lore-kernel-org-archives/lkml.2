Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1BUFif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:38:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54393 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1BUFie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hz83gg9jM5Mh5kl3RWbp32fv3pc5Xt0W2qsb9Py5BHAlTLN2sT6/27gHGNDwYNFVhz
         JGHn9TMwziMqeEzu6jSNcaIrb2YozOcZXHZHJDk3B2oK+cT+WEVmciyGy55mg6YXRM14
         tYTgMYBz7t+/prtYbgVEquIk0RturlveC63fM=
MIME-Version: 1.0
In-Reply-To: <1297865452-32181-2-git-send-email-s.hauer@pengutronix.de>
References: <1297865452-32181-1-git-send-email-s.hauer@pengutronix.de>
	<1297865452-32181-2-git-send-email-s.hauer@pengutronix.de>
Date: Mon, 21 Feb 2011 13:38:32 +0800
Message-ID: <AANLkTinQrXUwyRjehLr4YFiR66CRxT8ocEQMLXOEzHJx@mail.gmail.com>
Subject: Re: [PATCH 1/7] Add a mfd IPUv3 driver
From: Jason Chen <weitway@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Sascha,

I have few comments for this patch.

> +#define MX51_IPU_CHANNEL_CSI0                   0
> +#define MX51_IPU_CHANNEL_CSI1                   1
> +#define MX51_IPU_CHANNEL_CSI2                   2
> +#define MX51_IPU_CHANNEL_CSI3                   3
> +#define MX51_IPU_CHANNEL_MEM_BG_SYNC           23
> +#define MX51_IPU_CHANNEL_MEM_FG_SYNC           27
> +#define MX51_IPU_CHANNEL_MEM_DC_SYNC           28
> +#define MX51_IPU_CHANNEL_MEM_FG_SYNC_ALPHA     31
> +#define MX51_IPU_CHANNEL_MEM_DC_ASYNC          41
> +#define MX51_IPU_CHANNEL_ROT_ENC_MEM           45
> +#define MX51_IPU_CHANNEL_ROT_VF_MEM            46
> +#define MX51_IPU_CHANNEL_ROT_PP_MEM            47
> +#define MX51_IPU_CHANNEL_ROT_ENC_MEM_OUT       48
> +#define MX51_IPU_CHANNEL_ROT_VF_MEM_OUT                49
> +#define MX51_IPU_CHANNEL_ROT_PP_MEM_OUT                50
> +#define MX51_IPU_CHANNEL_MEM_BG_SYNC_ALPHA     51
Had better use MX5_IPU as prefix because it's same value in MX5X.

> +
> +       ipu_idmac_reg = ioremap(ipu_base + IPU_IDMAC_REG_BASE, PAGE_SIZE);
> +       if (!ipu_idmac_reg) {
> +               ret = -ENOMEM;
> +               goto failed_ioremap2;
> +       }
> +
> +       ret = ipu_mipi_setup();
> +       if (ret)
> +               goto failed_mipi_setup;
I dont know what's the best way to do it, but I think you had better
consider mx53 platform, so maybe this mipi_setup function and also
below ipu hw reset could be set in platform data.
> +
> +       ipu_clk = clk_get(&pdev->dev, "ipu");
> +       if (IS_ERR(ipu_clk)) {
> +               ret = PTR_ERR(ipu_clk);
> +               dev_err(&pdev->dev, "clk_get failed with %d", ret);
> +               goto failed_clk_get;
> +       }
> +
> +       ipu_get();
> +
> +       ret = request_irq(irq1, ipu_irq_handler, IRQF_DISABLED, pdev->name,
> +                       &pdev->dev);
> +       if (ret) {
> +               dev_err(&pdev->dev, "request irq %d failed with: %d\n", irq1, ret);
> +               goto failed_request_irq1;
> +       }
> +
> +       ret = request_irq(irq2, ipu_irq_handler, IRQF_DISABLED, pdev->name,
> +                       &pdev->dev);
> +       if (ret) {
> +               dev_err(&pdev->dev, "request irq %d failed with: %d\n", irq2, ret);
> +               goto failed_request_irq2;
> +       }
> +
> +       ipu_reset();
