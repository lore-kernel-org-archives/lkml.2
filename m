Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2DTM3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 08:29:46 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62224 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab2DTM3o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 08:29:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120420114602.GB3259@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
	<20120419124204.GE3046@opensource.wolfsonmicro.com>
	<CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
	<20120419162905.GA3084@opensource.wolfsonmicro.com>
	<CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
	<20120420114602.GB3259@opensource.wolfsonmicro.com>
Date: Fri, 20 Apr 2012 17:59:42 +0530
Message-ID: <CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 April 2012 17:16, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Apr 20, 2012 at 01:02:06PM +0530, Jassi Brar wrote:
>
>> Say, an audio CODEC chip has a simple PLL1 run by main voltage
>> domain(Vmain). PLL1 can only support 11025x sample rates.
>> Another PLL2 on the chip, powered by optional supply Vaux, could
>> provide 8000x sample rates. Obviously low-end platforms could choose
>> to not provide Vaux.
>
>> The platform has some other drivers that need to have dummy regulator
>> support enabled.
>
>> How is the CODEC driver supposed to know if 'vaux' is actually present?
>> Because if it isn't present, the driver wouldn't declare support for
>> 8000x  rates.
>> regulator_get() would always succeed, and regulator_is_enabled() would
>> always return 1, even if the vaux is not supplied.
>
> This is just one of those cases that won't ever work well with dummy
> regulators
>
That's what I have been trying to fix. My example might be fictitious but
I have a real scenario with omap_hsmmc (I was avoiding getting into that).

The dummy not just provide a place holder data structure for missing definition
of an available supply, but it also masks the fact that there might indeed be no
supply at all on the given machine.

As I said, atm the only option for a consumer is to know it via PD/DT.

We can avoid requiring this 'oob' info by simply letting the consumer driver
know that  "The platform didn't provide the supply, but here is a dummy
one in case you don't strictly require your supplies be completely defined
by all platforms".
Which can be achieved by simply adding that regulator_is_dummy() call.

The benefit is magnified by the fact that, for a given circuit, at
least theoretically,
there is no limit to the number/combination of supplies that could be controlled
by inserting a regulator. And that could lead to a very noisy PD/DT.

Thanks,
-Jassi
