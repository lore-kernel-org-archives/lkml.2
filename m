Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab1ADXwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:52:30 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34822 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1ADXw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:52:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cZnq6mjZrJ4fkujo+a7IPayRdcNk2XYbiSzZkC5DyXDBOksGPY08xOqfubGF5SPrsv
         6Fu5v2o3KstyJmNvWw+3De4asAV2EfZLaTqSVOMR3SHd7AnjMquZOuGLwCDuV4DrOr18
         76FEYxC71kqZNf2HpLJa6fYbzZAZhKV13ZT3M=
MIME-Version: 1.0
In-Reply-To: <1294002510-2324-1-git-send-email-tardyp@gmail.com>
References: <AANLkTin7OYXzCYty8pDxyzE_Bg83=+L8jmcaoEMSf4QM@mail.gmail.com>
	<1294002510-2324-1-git-send-email-tardyp@gmail.com>
Date: Wed, 5 Jan 2011 00:52:28 +0100
X-Google-Sender-Auth: jh4s3JeGqt3LDv7T5bl-8EcURXY
Message-ID: <AANLkTi=uqcFrWujZTG8zy9zQoZ+=O6N1VBSjzgQbfX3Q@mail.gmail.com>
Subject: Re: [PATCH] mmc: add MMC_QUIRK_BROKEN_CLK_GATING
From: Linus Walleij <linus.walleij@stericsson.com>
To: Pierre Tardy <tardyp@gmail.com>
Cc: "Gao, Yunpeng" <yunpeng.gao@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/2 Pierre Tardy <tardyp@gmail.com>:

> Some sdio card are not following sdio standard, and does not work
> when the sdio bus's clock is gated

Seem to me like it's pretty straight-forward and will work...
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index 82f4b90..6df1ead 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -785,6 +785,12 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
>
>        mmc_release_host(host);
>
> +        /*
> +         * see comments in mmc_host_may_gate_card()
> +         * this can be overidden by function drivers if they know that
> +         * their sdio card works with clock gating
> +         */
> +        card->quirks |= MMC_QUIRK_BROKEN_CLK_GATING;

...so the function driver will do something like this:

/* May gate clock */
card->quirks &= ~MMC_QUIRK_BROKEN_CLK_GATING;

Do you have a candidate function driver to do this ...?

Yours,
Linus Walleij
