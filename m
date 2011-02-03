Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1BCVHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:07:52 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57554 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1BCVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:07:51 -0500
Date: Thu, 3 Feb 2011 14:07:46 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: David Gibson <david@gibson.dropbear.id.au>, linux-kernel@vger.kernel.org,
        sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org
Subject: Re: [PATCH TIP v2 03/14] x86/dtb: Add a device tree for CE4100
Message-ID: <20110203210746.GI6180@angua.secretlab.ca>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-4-git-send-email-bigeasy@linutronix.de>
 <20110127050027.GB23443@yookeroo>
 <20110202185841.GA28674@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202185841.GA28674@www.tglx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 12:28:41AM +0530, Sebastian Andrzej Siewior wrote:
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
> - intel,ce4100-immr become intel,ce4100-cp. cp stands for core
>   peripherals. The Atom data sheet talks here about ACPI devices. Since
>   we don't have ACPI this does not apply here.
> - The interrupt map is gone. There are now plenty of device nodes.
> - The "unit address string" got fixed, it uses not DD,V format.

You can go ahead and keep the revision history above the s-o-b and ---
lines.  It turns out that having the revision history in the commit
text is actually useful when trying to figure out what version of a
patch actually got applied.

>  arch/x86/platform/ce4100/falconfalls.dts |  424 ++++++++++++++++++++++++++++++
>  1 files changed, 424 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/platform/ce4100/falconfalls.dts
> 
> diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
> new file mode 100644
> index 0000000..e888657
> --- /dev/null
> +++ b/arch/x86/platform/ce4100/falconfalls.dts
> @@ -0,0 +1,424 @@
> +/*
> + * CE4100 on Falcon Falls
> + *
> + * (c) Copyright 2010 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; version 2 of the License.
> + */
> +/dts-v1/;
> +/ {
> +	model = "intel,falconfalls";
> +	compatible = "intel,falconfalls";
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "intel,ce4100";
> +			reg = <0>;
> +			lapic = <&lapic0>;
> +		};
> +	};
> +
> +	soc@0 {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		compatible = "intel,ce4100-cp";

You'll need to add blurbs to Documentation/devicetree/bindings
(Documentation/powerpc/dts-bindings in Linus' tree; renamed in
linux-next) for each of these new compatible bindings to document the
part that they describe and any special properties that go with each
compatible value (if any).  You can send it as a followup patch.

> +				gpio@b,1 {
> +					compatible = "pci8086,2e67.2",
> +						   "pci8086,2e67",
> +						   "pciclassff0000",
> +						   "pciclassff00";
> +
> +					reg = <0x15900 0x0 0x0 0x0 0x0>;
> +					interrupts = <15 1>;
> +				};

You'll probably want to make use of the gpio-controller binding for
the gpio nodes so that other nodes can reference it.  Not a
showstopper for this patch though.

Otherwise looks good to me.
g.

