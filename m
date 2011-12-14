Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab1LNWZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:25:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64186 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1LNWZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:25:00 -0500
MIME-Version: 1.0
In-Reply-To: <4EE91FDD.5070206@gmail.com>
References: <1323896156-20692-1-git-send-email-linus.walleij@stericsson.com>
	<4EE91FDD.5070206@gmail.com>
Date: Wed, 14 Dec 2011 23:24:59 +0100
Message-ID: <CACRpkdZTCqcCmdqugwos+23Q5YXDcMvt48GFy8guVuSTWWtrpA@mail.gmail.com>
Subject: Re: [PATCH] irq: fix crash due to op-less irq domains
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:14 PM, Rob Herring <robherring2@gmail.com> wrote:
> Linus,
>
> On 12/14/2011 02:55 PM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> IRQ domains without ops does not work anymore after commit
>> "irq: support domains with non-zero hwirq base", since the
>> check dereferences domain->ops->to_irq without checking of
>> domain->ops are NULL. This makes U300 (and probably most other
>> systems using the PL190 VIC) boot again.
>
> I thought the VIC series had the fix for this, but it seems not. NULL
> ops is considered invalid based on the code comments. The correct fix is
> this patch:
>
> irqdomain: export irq_domain_simple_ops for !CONFIG_OF
> http://www.spinics.net/lists/arm-kernel/msg150290.html
>
> I believe this is going in with some iMX changes.

Can we please move this patch over to whatever branch the patch that
breaks my system is on, so I can create a proper fix for the
non-devicetree VIC users then?

Or apply an exact copy of the patch. Git will cope.

(Among the systems broken are likely the ARM Versatile too BTW,
not just obscure things like my U300.)

> But I guess the VIC is
> going to need a fix to use irq_domain_simple_ops.

If I just have the baseline in linux-next, I can fix it, but then I need
that patch in linux-next first, now all non-devicetree VIC systems are
just broken with no way for me to fix them :-(

Thanks,
Linus Walleij
