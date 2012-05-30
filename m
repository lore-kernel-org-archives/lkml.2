Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab2E3HPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:15:54 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:51775 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2E3HPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:15:52 -0400
MIME-Version: 1.0
In-Reply-To: <1338353260-10097-19-git-send-email-lee.jones@linaro.org>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
	<1338353260-10097-19-git-send-email-lee.jones@linaro.org>
Date: Wed, 30 May 2012 15:15:52 +0800
Message-ID: <CACRpkdYpCMRurpDgz5X-Qsv5qUgzeVX3S8trWHByTaw6R35_jg@mail.gmail.com>
Subject: Re: [PATCH 18/22] mfd: Remove redundant Kconfig entry
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 12:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> During ab8500-core clean-up the Kconfig entry for AB8500_I2C_CORE
> was left remnant. This patch simply removes it.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/Kconfig |   10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 11a1b65..b697136 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -660,16 +660,6 @@ config AB8500_CORE
>          the irq_chip parts for handling the Mixed Signal chip events.
>          This chip embeds various other multimedia funtionalities as well.
>
> -config AB8500_I2C_CORE
> -       bool "AB8500 register access via PRCMU I2C"
> -       depends on AB8500_CORE && MFD_DB8500_PRCMU

You need to move these dependencies under the AB8500_CORE config
entry instead.

> -       default y

I wonder if in  arch/arm/mach-ux500/Kconfig MACH_MOP500 should
select this instead, all MOP500 children have this an *won't* work
without it.

Yours,
Linus Walleij
