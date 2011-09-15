Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab1IOM2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:28:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34526 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459Ab1IOM2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:28:30 -0400
Message-ID: <4E71EF56.3050503@ti.com>
Date: Thu, 15 Sep 2011 14:28:06 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rob Herring <robherring2@gmail.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com> <4E71CE5D.9030900@ti.com> <20110915102915.GJ6267@n2100.arm.linux.org.uk>
In-Reply-To: <20110915102915.GJ6267@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/2011 12:29 PM, Russell King - ARM Linux wrote:
> On Thu, Sep 15, 2011 at 12:07:25PM +0200, Cousson, Benoit wrote:
>> On OMAP4 the SoC interrupts external to the MPU (SPI) have an offset of
>> 32. Only the internal PPI are between 0 and 31.
>
> SGIs are 0 to 15, PPIs are 16 to 31, and SPIs are 32+ - that's the
> numbering given to us by the GIC.
>
>> The real HW physical number start at 0, and thus this is that value that
>> should be in the irq binding of the device.
>
> That depends whether you're counting SPI number or whether you're counting
> IRQ number in the GIC interfaces.  SPI0 will be reported to us from the
> GIC as 32, not 0, so to start numbering from 0 (which is already frowned
> upon for many reasons) we'd have to subtract 32 after checking that the
> IRQ is not a SGI nor PPI in the assembly code instead.

The HW specs is obviously counting the IRQ number at the GIC interface.
That offset is not known outside the MPUSS. Please have a look at the 
OMAP4430 TRM p4761 (NDA vM version).
FWIW, the same numbering scheme is used on tegra2.

My proposal is just to handle the addition within the irq_domain_to_irq, 
so I'm not sure to understand your concern.

Regards,
Benoit



