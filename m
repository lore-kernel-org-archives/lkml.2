Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2HFLvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:51:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60267 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab2HFLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:51:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/6] mfd: Provide the PRCMU with its own IRQ domain
Date: Mon, 6 Aug 2012 11:50:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        dmitry.torokhov@gmail.com, sameo@linux.intel.com
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org> <1344250002-6011-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1344250002-6011-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208061150.53076.arnd@arndb.de>
X-Provags-ID: V02:K0:i8Y23CisuHn3qCtzT3ykxgN6mY8XtXNaokUfyvtqYvV
 Cl6chkFfGaa+lcKiJR3PDYNMsFOpRnLDOdlVh70Hj00UVNbgMW
 acnLSBE+gqUfSqqvCVGhRCf/HJ7gMXcSL9j5JC07WHKSBhfzn5
 d4Q+CYNnUgnGgyEtAynTTOV7VOnVJSXbE8gNlctElsJACgPPAY
 Y3UNMyNk6dTVcw0xiZXqwpY0cQMff08dg/6Zfta/3qTFPQEzyG
 UHxFOC2drcQNqHfO0eToM3F2fWIrnXKqxuNIwjrZrQq9Ql3Od+
 7QP1xdzAuHarj7c0ytVRtf7Dy7puMk/ziErYz5mvoszkjB3HAf
 ulEjRynfRXtxeOg3nTBs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2012, Lee Jones wrote:

>  
> +struct irq_domain *db8500_irq_domain;
> +
 
Should this be static?

> @@ -2583,7 +2585,7 @@ static void prcmu_irq_mask(struct irq_data *d)
>  
>         spin_lock_irqsave(&mb0_transfer.dbb_irqs_lock, flags);
>  
> -       mb0_transfer.req.dbb_irqs &= ~prcmu_irq_bit[d->irq - IRQ_PRCMU_BASE];
> +       mb0_transfer.req.dbb_irqs &= ~prcmu_irq_bit[d->hwirq];
>  
>         spin_unlock_irqrestore(&mb0_transfer.dbb_irqs_lock, flags);

Ah, so the hwirq number *is* used directly here, unlike what I thought
when we first discussed it. I suppose that means we don't need the
xlate function after all (and you did not add one).

	Arnd
