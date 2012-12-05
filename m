Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2LEWMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:12:09 -0500
Received: from antcom.de ([188.40.178.216]:38577 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab2LEWMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:12:07 -0500
Message-ID: <50BFC664.8080708@antcom.de>
Date: Wed, 05 Dec 2012 23:10:44 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de
Subject: Re: [PATCH 0/6 v8] gpio: Add block GPIO
References: <1354298637-25058-1-git-send-email-stigge@antcom.de> <50BC6E11.3040203@grandegger.com> <50BE5F8A.2000903@antcom.de> <50BF9627.4050102@grandegger.com>
In-Reply-To: <50BF9627.4050102@grandegger.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

On 05/12/12 19:44, Wolfgang Grandegger wrote:
>> * There is probably an explicit interrupt configuration necessary (via
>> struct gpio_block, and devicetree, respectively) since there are
>> constellations where gpio_to_irq() isn't working. E.g., in contrast to
>> controllers which are aware of their IRQs and providing to_irq(), there
>> is typically independent wiring from GPIO expander chips' interrupt line
>> to individual IRQ inputs on SoCs/CPUs. Or should all this be solved via
>> devicetree and drivers (which should support IRQ config where possible)?
> 
> Yes, I think it's up to the device tree or platform code to properly setup
> the interrupt... like for defining the GPIO block.

OK, sounds reasonable. Luckily, in reality it already works fine in this
regard with many current drivers.

>> * For the same reason, the IRQ flags are currently IRQF_TRIGGER_FALLING,
>> which isn't flexible. Instead, either preset by board setup/firmware, or
>> via interrupts config in devicetree (optional property of a GPIO block?)
> 
> Yes, and it did fail on my setup.

OK, will replace the flags with 0 (and need to fix my own board setup ;-) ).

>> * Some GPIOs' IRQs are not suitable for GPI input change detection. E.g.
>> on LPC32xx, I can configure the IRQ which is controlled directly by the
>> GPI's values as FALLING, RISING, HIGH /exclusive/ or LOW. I.e., this way
>> it's not possible to detect both 0->1 and 1->0 changes without
>> reconfiguring the GPIO controller inbetween. Other controllers provide a
>> dedicated interrupt on all values changes.
> 
> Hm.

For now, we are expecting IRQs to fire on "changes". Otherwise, the user
needs to handle the issue manually, using busy polling, manual
reconfiguration of the GPIO controller etc.

>> * Would IRQF_SHARED be appropriate to enable opening IRQ enabled GPIO
>> blocks multiple times?
> 
> Sounds reasonable for me. Some more comments in the patch mails...

OK, will do in the next update.

Thanks for your feedback,

Roland
