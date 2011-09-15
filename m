Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab1IOK3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:29:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43833 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1IOK3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:29:51 -0400
Date: Thu, 15 Sep 2011 11:29:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Rob Herring <robherring2@gmail.com>,
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
Message-ID: <20110915102915.GJ6267@n2100.arm.linux.org.uk>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com> <4E71CE5D.9030900@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E71CE5D.9030900@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 12:07:25PM +0200, Cousson, Benoit wrote:
> On OMAP4 the SoC interrupts external to the MPU (SPI) have an offset of  
> 32. Only the internal PPI are between 0 and 31.

SGIs are 0 to 15, PPIs are 16 to 31, and SPIs are 32+ - that's the
numbering given to us by the GIC.

> The real HW physical number start at 0, and thus this is that value that  
> should be in the irq binding of the device.

That depends whether you're counting SPI number or whether you're counting
IRQ number in the GIC interfaces.  SPI0 will be reported to us from the
GIC as 32, not 0, so to start numbering from 0 (which is already frowned
upon for many reasons) we'd have to subtract 32 after checking that the
IRQ is not a SGI nor PPI in the assembly code instead.
