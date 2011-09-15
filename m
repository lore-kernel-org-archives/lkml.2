Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1IOIum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:50:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48783 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1IOIul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 04:50:41 -0400
Date: Thu, 15 Sep 2011 09:50:36 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        marc.zyngier@arm.com, thomas.abraham@linaro.org, jamie@jamieiles.com,
        b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 0/5] GIC OF bindings
Message-ID: <20110915085036.GB3089@pulham.picochip.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 11:31:35AM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This series introduces of_irq_init to scan the device tree for interrupt
> controller nodes and call their init functions in proper order. The GIC
> init function is then called from this function. The platform code then
> looks something like this:
> 
> const static struct of_device_id irq_match[] = {
> 	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
> 	{}
> };
> 
> static void __init highbank_init_irq(void)
> {
> 	of_irq_init(irq_match);
> }
> 
> The binding for GIC PPIs is now done with a 3rd interrupt cell to specify
> a cpu mask for which cpu the PPI is connected to. This was discussed at LPC
> and suggested by Grant.
> 
> I dropped the public intc_desc struct. The the interrupt controller's node
> and the interrupt parent's node are passed in directly to the controller's
> init function. The linux irq assignment is now done dynamically using
> irq_alloc_descs.

Hi Rob,

This looks really nicely implemented to me.

Reviewed-by: Jamie Iles <jamie@jamieiles.com>

Jamie
