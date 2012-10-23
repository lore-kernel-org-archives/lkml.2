Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab2JWIbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:31:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51428 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2JWIbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:31:46 -0400
MIME-Version: 1.0
In-Reply-To: <5085A7CA.3070001@wwwdotorg.org>
References: <1350659375-7335-1-git-send-email-linus.walleij@stericsson.com>
	<50817E43.8000804@wwwdotorg.org>
	<CACRpkdbcTT_Mfa67Vw_6Y3RvqOE3CMA7kNXLG5oja0uTNn1FoA@mail.gmail.com>
	<5085A7CA.3070001@wwwdotorg.org>
Date: Tue, 23 Oct 2012 10:31:45 +0200
Message-ID: <CACRpkdZLgnEHAKiyZBT1FTQPdp69rTOQ9ba9ZQ0y4eLODw4zeA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/nomadik: use irq_create_mapping()
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:08 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/22/2012 02:14 AM, Linus Walleij wrote:

>> It's an IRQ handler so it should be robust to spurious IRQs due to
>> transient hardware states etc I believe.
>>
>> So if there is a transient IRQ before gpio_to_irq() is called -> boom.
>
> I wonder though (a) why it would be unmasked in HW, and (b) why the
> software would even look at the status bit if no handler were registered?

That's true of course ... OK I'll update the patch.

Still I'm not feeling good about the irq_create_mapping/irq_find_mapping
separation, I think a lot of drivers just get this wrong and it's causing
bugs... it'd be way better if there was just one of them and we could
count on descriptors being allocated after adding any kind of irqdomain
but I have no clue how hard it would be to achieve this.

Yours,
Linus Walleij
