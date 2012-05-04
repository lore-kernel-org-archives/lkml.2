Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab2EDMdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:33:52 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:49107 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416Ab2EDMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:33:51 -0400
Message-ID: <4FA3CCAF.3020902@ti.com>
Date: Fri, 04 May 2012 15:33:51 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120503 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
References: <20120503132004.GB14296@sirena.org.uk> <4FA2881B.6010902@ti.com> <20120503145248.GJ3955@opensource.wolfsonmicro.com> <4FA2A08C.5000403@ti.com> <20120503152643.GM3955@opensource.wolfsonmicro.com> <4FA3958A.4080206@ti.com> <20120504090856.GA14230@opensource.wolfsonmicro.com> <4FA3B182.5060001@ti.com> <20120504112204.GE14230@opensource.wolfsonmicro.com> <4FA3C3B9.3030009@ti.com> <20120504121730.GG14230@opensource.wolfsonmicro.com>
In-Reply-To: <20120504121730.GG14230@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 03:17 PM, Mark Brown wrote:
>> You mean on devices like twl6040, twl6030, twl4030 (I2C MFD devices)?
>> Or "irq expander" type of devices?
> 
> The latter, and also just any driver that delivers an interrupt via a
> GPIO on OMAP - if the GPIO IRQ numbers are all dynamically allocated
> then it gets hard to register an off-chip device and tell it which
> interrupt to request.

For GPIO IRQ there's the gpio_to_irq() call which returns the mapped IRQ
number for the given GPIO.
If there is "irq expander" type of chip I assume it would have similar
way to get the IRQ number based on either GPIO number or some other
enumeration value.
The twl6040 does not have such a feature. The interrupts are generated
internally and it has one IRQ line towards the host. We have nested
interrupts for the childs (plug detect is handled by ASoC codec, Vibra
overcurrent is handled by the vibra driver, etc).
Client drivers got their interrupts via platform_get_irq(); they does
not need to know anything about irq_base, or where the IRQ number has
been mapped.

-- 
Péter
