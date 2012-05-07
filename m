Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab2EGGtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:49:47 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:47940 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab2EGGtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:49:45 -0400
Message-ID: <4FA77093.9060306@ti.com>
Date: Mon, 07 May 2012 09:49:55 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120503 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
References: <20120503145248.GJ3955@opensource.wolfsonmicro.com> <4FA2A08C.5000403@ti.com> <20120503152643.GM3955@opensource.wolfsonmicro.com> <4FA3958A.4080206@ti.com> <20120504090856.GA14230@opensource.wolfsonmicro.com> <4FA3B182.5060001@ti.com> <20120504112204.GE14230@opensource.wolfsonmicro.com> <4FA3C3B9.3030009@ti.com> <20120504121730.GG14230@opensource.wolfsonmicro.com> <4FA3CCAF.3020902@ti.com> <20120504124750.GL14230@opensource.wolfsonmicro.com>
In-Reply-To: <20120504124750.GL14230@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 03:47 PM, Mark Brown wrote:
> This doesn't really work for board files, though - you can only call
> gpio_to_irq() at runtime so if you're statically registering the devices
> on the board you'd need to make the structures non-const, manage to find
> the GPIO controller at runtime then do the lookup, update the struct and
> finally register the device.

I've seen some board files doing this already (obviously not for the
twl6040). Which is not the nicest thing...

>> If there is "irq expander" type of chip I assume it would have similar
>> way to get the IRQ number based on either GPIO number or some other
>> enumeration value.
> 
> No, there's no generic interface for this.

This dynamic range allocation for IRQ, GPIO will work nicely with DT at
the end. In legacy way we will need to have workarounds. Or just forget
about booting without DT.

>> The twl6040 does not have such a feature. The interrupts are generated
>> internally and it has one IRQ line towards the host. We have nested
>> interrupts for the childs (plug detect is handled by ASoC codec, Vibra
>> overcurrent is handled by the vibra driver, etc).
> 
> OK, that's fine then - you should put this in the changelog to make it
> clear that there are no external users who could be affected.

I'll do that.

Thank you,
Péter
