Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1JZGVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:21:24 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10979 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1JZGVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:21:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 25 Oct 2011 23:21:16 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Chanho Park <chanho61.park@samsung.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>
Date: Tue, 25 Oct 2011 23:21:13 -0700
Subject: RE: [PATCH] drivers: pinctrl: add a pin_base for sparse gpio-ranges
Thread-Topic: [PATCH] drivers: pinctrl: add a pin_base for sparse gpio-ranges
Thread-Index: AcyTlt07UXZp9UagRbu8use0Yme9FAAEBtnA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B452D@HQMAIL01.nvidia.com>
References: <1319602943-17946-1-git-send-email-chanho61.park@samsung.com>
In-Reply-To: <1319602943-17946-1-git-send-email-chanho61.park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanho Park wrote at Tuesday, October 25, 2011 10:22 PM:
> This patch enables mapping a base offset of gpio ranges with
> a pin offset even if does'nt matched. A base of pinctrl_gpio_range
> means a base offset of gpio. However, we cannot convert gpio to pin
> number for sparse gpio ranges just only using a gpio base offset.
> We can convert a gpio to real pin number(even if not matched) using
> a new pin_base which means a base pin offset of requested gpio range.
...
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
...
> @@ -289,38 +291,12 @@ So this complex system has one pin controller handling two different
>  GPIO chips. Chip a has 16 pins and chip b has 8 pins. They are mapped in
>  the global GPIO pin space at:
> 
> -chip a: [32 .. 47]
> -chip b: [48 .. 55]
> -
> -When GPIO-specific functions in the pin control subsystem are called, these
> -ranges will be used to look up the apropriate pin controller by inspecting
> -and matching the pin to the pin ranges across all controllers. When a
> -... [ quit a few lines of documentation removed]
> -(If the GPIO subsystem is ever refactored to use a local per-GPIO controller
> -pin space, this mapping will need to be augmented accordingly.)
> -
> +chip a:
> +	gpio-range : [32 .. 47]
> +	pin-range  : [32 .. 47]
> +chip b:
> +	gpio-range : [48 .. 55]
> +	pin-range  : [64 .. 71]

I'm all for replacing the example here with something more complete, but
removing all that text from the documentation doesn't seem right.

...
> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
> index 90dd28b..7768e44 100644
> --- a/include/linux/pinctrl/pinctrl.h
> +++ b/include/linux/pinctrl/pinctrl.h
> @@ -127,6 +127,7 @@ struct pinctrl_pin_desc {
>   * @name: a name for the chip in this range
>   * @id: an ID number for the chip in this range
>   * @base: base offset of the GPIO range
> + * @pin_base: base pin offset of the GPIO range

This may be bike-shedding, but I'd tend to call this "gpio_base", since
it's the first "gpio" number of this range, not the first "pin" number
("pins" are used in the pinctrl subsystem, but "gpios" by the GPIO
Subsystem)

-- 
nvpublic

