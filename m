Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700Ab2EVQk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:40:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47034 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab2EVQkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:40:53 -0400
Message-ID: <4FBBC192.7030900@wwwdotorg.org>
Date: Tue, 22 May 2012 10:40:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: swarren@nvidia.com, olof@lixom.net, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com> <1337691917-15040-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1337691917-15040-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 07:05 AM, Laxman Dewangan wrote:
> Add device info for the PMIC device tps65911 in tegra-cardhu
> dts file. This device supports the multiple regulator rails,
> gpio, interrupts.

FYI, patch 1 in this series looks fine. Some comments below though:

> diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts

> +		tps65911: tps65911@2d {
> +			compatible = "ti,tps65911";
> +			reg = <0x2d>;
> +
> +			#gpio-cells = <2>;
> +			gpio-controller;
> +
> +			regulators {

Please add the following properties here:

	#address-cells = <1>;
	#size-cells = <0>;

> +				vdd1_reg: vdd1 {

This node name should be "regulator", since nodes are generally named
after the class of object they represent. Since all the nodes will then
have the same name, you'll need to add a unit address ("@nnnn") to the
node name.

Nitpicky, but the labels might be more logical as reg_vdd1 rather than
vdd1_reg, but not a big deal.

So, please replace the line above with:

	reg_vdd1: regulator@0 {
		reg = <0>;

> +					regulator-name = "vdd1";
> +					regulator-min-microvolt = < 600000>;
> +					regulator-max-microvolt = <1500000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				vdd2_reg: vdd2 {

And similarly, that would become:

	reg_vdd2: regulator@1 {
		reg = <1>;

etc.
