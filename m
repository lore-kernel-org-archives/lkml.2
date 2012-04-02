Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2DBNRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 09:17:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51587 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2DBNRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 09:17:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 5/7] i2c: Add device tree support to i2c-pnx.c
Date: Mon, 2 Apr 2012 13:17:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be
References: <1333371364-21347-1-git-send-email-stigge@antcom.de> <1333371364-21347-6-git-send-email-stigge@antcom.de>
In-Reply-To: <1333371364-21347-6-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204021317.23393.arnd@arndb.de>
X-Provags-ID: V02:K0:hckhPoG0YDuseucwoYIdDrpbdcgGnXtkVhpiorbdVRd
 Ji4+WBft9MF9v5CBl6lsx5rDvG9V7sq7LcXfdv2gURVZmLJcVk
 IKuycPoaDlmXsg7kiKEvs1WSBVV0cVTGz4j+HBzt9D190xz4NU
 Ga1pHnAb+3SvJAZMV/3yl5ujykfUXI7sf+KHAQdKh7qBIxGu1y
 5Iw2tAFgWvMqdnJgqiCFFsCZGzvrWDSoZQkjvzFl9eBENddgAA
 +bG3EVfT72VGiRDQbLmtMhXjq8f5Hfw3DqWa29rj1zgV76c8+q
 r7035UmpORN90aaI0ROMrBuPV4/vYEXlhSxhJCXCUW6DCCYmK+
 1aXSES41yZBMOlDMhY7g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2012, Roland Stigge wrote:

> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/i2c/pnx.txt
> @@ -0,0 +1,36 @@
> +* NXP PNX I2C Controller
> +
> +Required properties:
> +
> + - reg: Offset and length of the register set for the device
> + - compatible: should be "nxp,pnx-i2c"
> + - interrupts: <a b> where a is the interrupt number and b is a
> +   field that represents an encoding of the sense and level
> +   information for the interrupt

The encoding of the interrupt is specific to the controller and does
not belong here. Just write that there is one interrupt line to be
configure.

> + - interrupt-parent: the phandle for the interrupt controller that
> +   services interrupts for this device.

interrupt-parent should be optional, it can be set in the (grand-)parent
device on systems where all devices use the same controller.

You should also require

#address-cells = <1>;
#size-cells = <0>;

To create an address space for i2c slave device numbers.
> +Examples:
> +
> +	i2c1: i2c@400A0000 {
> +		compatible = "nxp,pnx-i2c";
> +		reg = <0x400A0000 0x100>;
> +		interrupt-parent = <&mic>;
> +		interrupts = <51 0>;
> +	};
> +
> +	i2c2: i2c@400A8000 {
> +		compatible = "nxp,pnx-i2c";
> +		reg = <0x400A8000 0x100>;

Best use all lowercase letters in the addresses.

> +		interrupt-parent = <&mic>;
> +		interrupts = <50 0>;
> +		clock-frequency = <0x186a0>;
> +		pnx,timeout = <0x64>;
> +		slave-addr = <0x11>;
> +	};

>  static struct platform_driver i2c_pnx_driver = {
>  	.driver = {
>  		.name = "pnx-i2c",
>  		.owner = THIS_MODULE,
> +#ifdef CONFIG_OF
> +		.of_match_table = i2c_pnx_of_match,
> +#endif
>  	},
>  	.probe = i2c_pnx_probe,
>  	.remove = __devexit_p(i2c_pnx_remove),

of_match_ptr() instead of this #ifdef, please.

	Arnd
