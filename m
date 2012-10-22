Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2JVIOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:14:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57493 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2JVIOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:14:06 -0400
MIME-Version: 1.0
In-Reply-To: <50817E43.8000804@wwwdotorg.org>
References: <1350659375-7335-1-git-send-email-linus.walleij@stericsson.com>
	<50817E43.8000804@wwwdotorg.org>
Date: Mon, 22 Oct 2012 10:14:05 +0200
Message-ID: <CACRpkdbcTT_Mfa67Vw_6Y3RvqOE3CMA7kNXLG5oja0uTNn1FoA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/nomadik: use irq_create_mapping()
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 6:22 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/19/2012 09:09 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>
>> @@ -931,7 +931,7 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
>>       while (status) {
>>               int bit = __ffs(status);
>>
>> -             generic_handle_irq(irq_find_mapping(nmk_chip->domain, bit));
>> +             generic_handle_irq(irq_create_mapping(nmk_chip->domain, bit));
>
> Surely this one can remain as irq_find_mapping() since isn't
> nmk_gpio_to_irq() guaranteed to have been called first for this GPIO/IRQ?

It's an IRQ handler so it should be robust to spurious IRQs due to
transient hardware states etc I believe.

So if there is a transient IRQ before gpio_to_irq() is called -> boom.

Yours,
Linus Walleij
