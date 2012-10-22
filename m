Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2JVUIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:08:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47047 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab2JVUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:08:45 -0400
Message-ID: <5085A7CA.3070001@wwwdotorg.org>
Date: Mon, 22 Oct 2012 14:08:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] pinctrl/nomadik: use irq_create_mapping()
References: <1350659375-7335-1-git-send-email-linus.walleij@stericsson.com> <50817E43.8000804@wwwdotorg.org> <CACRpkdbcTT_Mfa67Vw_6Y3RvqOE3CMA7kNXLG5oja0uTNn1FoA@mail.gmail.com>
In-Reply-To: <CACRpkdbcTT_Mfa67Vw_6Y3RvqOE3CMA7kNXLG5oja0uTNn1FoA@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 02:14 AM, Linus Walleij wrote:
> On Fri, Oct 19, 2012 at 6:22 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 10/19/2012 09:09 AM, Linus Walleij wrote:
>>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>>> @@ -931,7 +931,7 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
>>>       while (status) {
>>>               int bit = __ffs(status);
>>>
>>> -             generic_handle_irq(irq_find_mapping(nmk_chip->domain, bit));
>>> +             generic_handle_irq(irq_create_mapping(nmk_chip->domain, bit));
>>
>> Surely this one can remain as irq_find_mapping() since isn't
>> nmk_gpio_to_irq() guaranteed to have been called first for this GPIO/IRQ?
> 
> It's an IRQ handler so it should be robust to spurious IRQs due to
> transient hardware states etc I believe.
> 
> So if there is a transient IRQ before gpio_to_irq() is called -> boom.

I wonder though (a) why it would be unmasked in HW, and (b) why the
software would even look at the status bit if no handler were registered?

