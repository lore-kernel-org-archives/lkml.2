Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2JDHM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:12:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2JDHM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:12:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 2/6] mfd: da9052: Introduce da9052-irq.c
Date: Thu, 4 Oct 2012 07:12:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com> <1349320509-26930-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1349320509-26930-2-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210040712.48516.arnd@arndb.de>
X-Provags-ID: V02:K0:onk9C9N6KGp7XWqimm3Q/mXw9uXiGx3RkV4U7O1VzTT
 LoQBNv56QN0IEQHvpsZa2Yv614EhorStrjkNxEFe8NbwdT+90G
 tdXfazotgM/FU0a3mTi+LdrutB4uQINCOwOhQIorHXelg9/LJW
 yHKu2oK3UPPHo5kZEYXd2LG9WlKrO27BU17/IGpx69amCCXKIv
 gpzaT5pQEIGwKMEhfsSBAiNnvHU0w5lswghGB3gyldKS7qU1m0
 Z8SL437MO7RnXjg0FZegtsBe93S/HLJVSnZeMVzLUrYGZtb/FK
 cNJLnbpmZXgKgd2BOArP24tAd0OVZ5QLwchBnJos97cqcUDFfg
 Vm+SyQHOoi9xR3ag8nbQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2012, Fabio Estevam wrote:
> +static int da9052_map_irq(struct da9052 *da9052, int irq)
> +{
> +       return regmap_irq_get_virq(da9052->irq_data, irq);
> +}
> +
> +int da9052_enable_irq(struct da9052 *da9052, int irq)
> +{
> +       irq = da9052_map_irq(da9052, irq);
> +       if (irq < 0)
> +               return irq;
> +
> +       enable_irq(irq);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(da9052_enable_irq);

This looks correct, but I'm not sure it's actually simpler
than letting the sub-drivers deal with calling regmap_irq_get_virq().

Can't each driver just call regmap_irq_get_virq once at init time and
then call the regular irq management functions?

Maybe I just don't see the real purpose of these functions. If I'm
contradicting what Mark said, listen to him instead.

	Arnd
