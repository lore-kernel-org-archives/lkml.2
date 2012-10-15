Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2JOOKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:10:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54678 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2JOOKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:10:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/2] Documentation: Describe Device Tree bindings for GPIO Regulator driver
Date: Mon, 15 Oct 2012 14:10:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1350307020-5910-1-git-send-email-lee.jones@linaro.org> <1350307020-5910-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1350307020-5910-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210151410.16516.arnd@arndb.de>
X-Provags-ID: V02:K0:XCNVLUY9SzFktxRE9W+vSHdFFZQ36/EXjJTK7awutKQ
 +5WSTtSSjS+EcTTErG9aaoVUwzh4NPbZFuPzOZP33j887opy5n
 cnOEToIpH+084dqURkYQxFQji8DUfgMIiPOJ8o9g8G7xnPB0k7
 ZjYXsKkdStsqaejYpusbN2k21I+HP9G+784Ch839bo54V5rNJf
 15Xcn4ZcHFLzqz6qUutbnHP8dDjM0gYp3fytY0R+KDXRjlBfas
 2LvY5elghLibT1QdemmdbD4C5zuQwLnVWx4zoBgD7jLq0I/ngn
 PwSpSPve/JHt84dru/OHvCnD2lFM3vLDuZb6MvDj4KWJb5NtWA
 ungmG+q4u52jFycPHyOQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012, Lee Jones wrote:
> diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
> new file mode 100644
> index 0000000..5f77ee0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
> @@ -0,0 +1,25 @@
> +GPIO controlled regulators
> +
> +Required properties:
> +- compatible            : Must be "regulator-gpio".
> +
> +Optional properties:
> +- gpio-enable           : GPIO to use to enable/disable the regulator.
> +- startup-delay-us      : Startup time in microseconds.
> +- enable-active-high    : Polarity of GPIO is active high (default is low).
> +
> +Any property defined as part of the core regulator binding defined in
> +regulator.txt can also be used.
> +
> +Example:
> +
> +       mmciv: gpio-regulator {
> +               compatible = "regulator-gpio";
> +               regulator-name = "mmci-gpio-supply";
> +               regulator-min-microvolt = <1800000>;
> +               regulator-max-microvolt = <2600000>;
> +               gpio = <&gpio0 24 0x4>;
> +               startup-delay-us = <100000>;
> +               enable-active-high;
> +               regulator-boot-on;
> +       };

The example doesn't match the documentation for the name of the gpio property
("gpio" vs. "gpio-enable"). I think the convention is to use "gpios".

Shouldn't this property be mandatory? I think there is little point in
defining a gpio-regulator without a gpio line attached to it.

Finally, the "enable-active-high" looks redundant, as that is something
that is normally encoded in the "gpios" property.

	Arnd
