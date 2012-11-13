Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2KMFAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:00:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36313 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2KMFAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:00:46 -0500
Message-ID: <50A1D3FC.9010207@wwwdotorg.org>
Date: Mon, 12 Nov 2012 22:00:44 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: linux-mips@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Kevin Cernekee <cernekee@gmail.com>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [RFC] MIPS: BCM63XX: add Device Tree glue code for IRQ handling
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com> <1352638249-29298-5-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1352638249-29298-5-git-send-email-jonas.gorski@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 05:50 AM, Jonas Gorski wrote:
> Register IRQ domains through Device Tree for the internal and external
> interrupt controllers. Register the same IRQ ranges as previously to
> provide backward compatibility for non-DT drivers.

> diff --git a/Documentation/devicetree/bindings/mips/bcm63xx/epic.txt b/Documentation/devicetree/bindings/mips/bcm63xx/epic.txt

Rather than putting binding docs in an arch-specific directory, perhaps
put them into a device-type-specific directory, such as
bindings/interrupt-controller/brcm,bcm63xx-epic.txt?

> +- #interrupt-cells: <2>
> +  This controller supports level and edge triggered interrupts. The
> +  first cell is the interrupt number, the second is a 1:1 mapping to
> +  the linux interrupt flags.

The DT documentation should be self-contained, and not reference
anything OS-specific. In this case, you could reference
Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
for the interrupt flags.

> diff --git a/arch/mips/bcm63xx/dts/bcm6328.dtsi b/arch/mips/bcm63xx/dts/bcm6328.dtsi

>  		ranges = <0 0x10000000 0x20000>;
>  		compatible = "simple-bus";
> +
> +		interrupt-parent = <&ipic>;
> +
> +		perf@0 {
> +			epic: interrupt-controller@18 {

Don't you need some reg properties in the perf and interrupt-controller
nodes so that the register address can be determined?

> +				compatible = "brcm,bcm63xx-epic";
> +				interrupt-controller;
> +				#interrupt-cells = <2>;
> +			};

