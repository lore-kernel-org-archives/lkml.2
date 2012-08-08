Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2HHO23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:28:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53419 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2HHO2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <201208080919.52592.arnd@arndb.de>
References: <1344389967-8465-1-git-send-email-linux@prisktech.co.nz>
	<1344389967-8465-9-git-send-email-linux@prisktech.co.nz>
	<CACRpkdbYxpN9RCu8j8KMBgrb=-DsYZHq7hx-ifmHhJ0ZZcRYjw@mail.gmail.com>
	<201208080919.52592.arnd@arndb.de>
Date: Wed, 8 Aug 2012 16:28:24 +0200
Message-ID: <CACRpkdabUWpDsBhz4ZEJNhEuqw-U+v-HrX7NcWoNLeuenv5t9A@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 8/8] ARM: vt8500: gpio: Devicetree support for arch-vt8500
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        Neil Zhang <zhangwm@marvell.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Rob Landley <rob@landley.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>,
        Eric Andersson <eric.andersson@unixphere.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 11:19 AM, Arnd Bergmann <arnd@arndb.de> wrote:

>> What on earth are all those magic numbers?
>>
>> I *guess* they're enabling some default GPIO settings etc.
>
> No, they are the register offsets you quoted above, per bank.

Aha I was fooled by this:

+struct vt8500_gpio_bank_regs {
+       int     en;
+       int     dir;
+       int     data_out;
+       int     data_in;
+       int     ngpio;
+};

This needs to be named something intuitive like "vt8500_gpio_bank_regoffsets"

Some kerneldoc intsead of the opaque comment above will also improve
readability a lot:

/**
  * struct vt8500_gpio_bank_regoffsets
  * @en: offset to enable register in the bank
  * ...

Yours,
Linus Walleij
