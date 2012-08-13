Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2HMNjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:39:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65021 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2HMNjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:39:44 -0400
MIME-Version: 1.0
In-Reply-To: <5028CDED.2020307@samsung.com>
References: <5028CDED.2020307@samsung.com>
Date: Mon, 13 Aug 2012 15:39:43 +0200
Message-ID: <CACRpkdZMbcX9u5rcwwUhZStjr_aoKcFSuEf0rK8YzEJ_rqq0TQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: card: Skip secure option for MoviNAND.
From: Linus Walleij <linus.walleij@linaro.org>
To: IAN CHEN <ian.cy.chen@samsung.com>
Cc: cjb@laptop.org, linkinjeon@gmail.com, adrian.hunter@intel.com,
        subhashj@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, d.j.shin@samsung.com,
        jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 11:50 AM, IAN CHEN <ian.cy.chen@samsung.com> wrote:

> For several MoviNAND, there are some known issue with secure option.
> For these specific MoviNAND device, we skip secure option.

OK..

> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 111aca5..4505a30 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -239,6 +239,7 @@ struct mmc_card {
>  #define MMC_QUIRK_BLK_NO_CMD23    (1<<7)        /* Avoid CMD23 for
> regular multiblock */
>  #define MMC_QUIRK_BROKEN_BYTE_MODE_512 (1<<8)    /* Avoid sending 512
> bytes in */
>  #define MMC_QUIRK_LONG_READ_TIME (1<<9)        /* Data read time > CSD
> says */
> +#define MMC_QUIRK_MOVINAND_SECURE (1<<10)    /* MoviNAND secure issue */
>                          /* byte mode */
>      unsigned int    poweroff_notify_state;    /* eMMC4.5 notify feature */
>  #define MMC_NO_POWER_NOTIFICATION    0

So if there is a FOO memory with broken secure features I will have to add
MMC_QUIRK_FOO_SECURE  etc?

No thanks, name the flag something netral that can be reused, like
MMC_QUIRK_SECURE_MODE_BROKEN, simply.

Yours,
Linus Walleij
