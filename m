Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2I0L7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:59:14 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60311 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2I0L7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <5063E06A.6000205@nvidia.com>
References: <1348679887-2135-1-git-send-email-linus.walleij@stericsson.com>
	<5063E06A.6000205@nvidia.com>
Date: Thu, 27 Sep 2012 13:59:08 +0200
Message-ID: <CACRpkdYdU-4yszhbJ5ZkyfncVpObdy0Ah=kz7pSpZ=HGgFax7Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/nomadik: allocate IRQ descriptors dynamically
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 7:13 AM, Stephen Warren <swarren@nvidia.com> wrote:
> On 09/26/2012 11:18 AM, Linus Walleij wrote:

>> +     irq_start = NOMADIK_GPIO_TO_IRQ(pdata->first_gpio);
>
> Presumably that's a 1:1 mapping...

Yep, albeit on a legacy domain to be able to keep the start irq.

>> +     irq_base = irq_alloc_descs(irq_start, 0, NMK_GPIO_PER_CHIP,
>> +                                numa_node_id());
>> +     if (IS_ERR_VALUE(irq_base)) {
>> +             WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
>> +                  irq_start);
>> +             irq_base = irq_start;
>> +     }
>
> Hmmm. Is this code targetting the DT case or the non-DT case or both? I
> think typically you'd call irq_domain_add_linear without forcing a
> particular IRQ base for the DT case, and only call irq_alloc_descs() for
> the non-DT case, right?

This is indeed the non-DT case. The irqdomain stuff here doesn't seem
to be properly addressing the DT usecase. I'll cook a v2 version doing
a linear domain for DT and have Lee review it.

Thanks!
Linus Walleij
