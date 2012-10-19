Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab2JSPtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:49:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37324 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2JSPs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:48:59 -0400
Message-ID: <50817668.6020709@wwwdotorg.org>
Date: Fri, 19 Oct 2012 09:48:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dt: tegra: ventana: define pinmux for ddc
References: <1350626311-18131-1-git-send-email-markz@nvidia.com>
In-Reply-To: <1350626311-18131-1-git-send-email-markz@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 11:58 PM, Mark Zhang wrote:
> Define pinmux for DDC. The DDC pinmux in Ventana is 2 pins in I2C2.

> +++ b/arch/arm/boot/dts/tegra20-ventana.dts

> -			ddc {
> -				nvidia,pins = "ddc", "owc", "spdi", "spdo",
> -					"uac";
> -				nvidia,function = "rsvd2";
> -			};

So that removes the entries for 5 pin groups, yet below, entries are
only added for the ddc and pta pingroups, so the other 4 pin groups
become unconfigured.

> +
> +		state_i2cmux_ddc: pinmux_i2cmux_ddc {
> +			ddc {
> +				nvidia,pins = "ddc";
> +				nvidia,function = "i2c2";
> +			};
> +			pta {
> +				nvidia,pins = "pta";
> +				nvidia,function = "rsvd4";
> +			};

Does this actually work? The pta pingroup is configured by the "hog"
pinctrl state of the pinctrl node itself, so this state should fail to
be applied since it attempts to touch the same pingroup.

> +	i2cmux {
...
> +		i2c@1 {
> +			reg = <1>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			smart-battery@b {
> +				compatible = "ti,bq24617", "smart-battery-1.1";
> +				reg = <0xb>;
> +				ti,i2c-retry-count = <2>;
> +				ti,poll-retry-count = <10>;
> +			};

That wasn't there before. Does that device actually exist on Ventana?
Adding it should be a separate patch if so, since this one is just about
introducing the I2C mux, not adding an SBS device. Was this all just
cut/paste from Seaboard without validation?
