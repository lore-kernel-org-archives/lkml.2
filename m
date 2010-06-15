Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab0FOVSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 17:18:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38789 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab0FOVSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 17:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MgZpyOqWatJzmQEK18GohJEnQaK9F/dYzywMd1NGxO7gfd90Yppreb/9FkpcbCMzH4
         0dtzdinrWgJJpmBxG9HQq1hs9U+nLLFx2yJA637kRK3vhbmmylUV8200FMRY4F2rmQb5
         gmBjgR/IY5zuAzy+bS7BbeDAhuOvYzSdnpUOU=
MIME-Version: 1.0
In-Reply-To: <1276636268-4891-2-git-send-email-gbean@codeaurora.org>
References: <1276636268-4891-1-git-send-email-gbean@codeaurora.org> 
	<1276636268-4891-2-git-send-email-gbean@codeaurora.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Jun 2010 17:18:12 -0400
Message-ID: <AANLkTinSE9pO-UtNyTecEovU7gG9G1PIwK_-0__XflrP@mail.gmail.com>
Subject: Re: [PATCH 1/2 v4] gpio: msm7200a: Add gpiolib support for MSM chips.
To: Gregory Bean <gbean@codeaurora.org>
Cc: akpm@linux-foundation.org, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 17:11, Gregory Bean wrote:
> +config GPIO_MSM7200A
> +       tristate "Qualcomm MSM7200A SoC GPIO support"
> +       depends on GPIOLIB
> +       help
> +         Say yes here to support GPIO functionality on Qualcomm's
> +         MSM chipsets which descend from the MSM7200a:
> +         MSM7x01(a), MSM7x25, MSM7x27, MSM7x30, QSD8x50(a).

you should mention the module name in the help text

> +static int msm_gpio_probe(struct platform_device *dev)

should have __devinit markings

> +static int msm_gpio_remove(struct platform_device *dev)

__devexit

> +       .remove = msm_gpio_remove,

__devexit_p()

> +postcore_initcall(msm_gpio_init);

does this really need to be postcore rather than module ?
-mike
