Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2HVNgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:36:51 -0400
Received: from 115-188-14-127.jetstream.xtra.co.nz ([115.188.14.127]:49502
	"EHLO SERVER.prisktech.co.nz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932200Ab2HVNgr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:36:47 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "vt8500-wm8505-linux-kernel@googlegroup.com" 
	<vt8500-wm8505-linux-kernel@googlegroup.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Turquette <mturquette@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: RE: [rtc-linux] [PATCHv3 8/9] arm: vt8500: gpio: Devicetree support
 for arch-vt8500
Thread-Topic: [rtc-linux] [PATCHv3 8/9] arm: vt8500: gpio: Devicetree
 support for arch-vt8500
Thread-Index: AQHNgEchDVSh9DXJqUai2eYKY8yPZZdlzvKT
Date: Wed, 22 Aug 2012 13:33:52 +0000
Message-ID: <76F764B079F92A4E843589C893D0A022DAF67144@SERVER.prisktech.co.nz>
References: <1345582058-2291-1-git-send-email-linux@prisktech.co.nz>
	<1345582058-2291-9-git-send-email-linux@prisktech.co.nz>,<CACRpkdZnQyLSRQ6cRpFBurAv2cv44einGAsT86FLCqsj1euDMA@mail.gmail.com>
In-Reply-To: <CACRpkdZnQyLSRQ6cRpFBurAv2cv44einGAsT86FLCqsj1euDMA@mail.gmail.com>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Converted the existing arch-vt8500 gpio to a platform_device.
>> Added support for WM8505 and WM8650 GPIO controllers.
>(...)
>> +       unsigned val;

>I asked about the datatype for this "val", it sure isn't "unsigned".

>I suspected the registers were only 8bit and so it should be u8.
>But atleast use u32 if you must use all these bits.

Sorry - missed adding this to my list of fixes. I've used u32 as the
datasheet advises these are 32-bit registers and must be
read/written as such.
Changes included in v4.

>(...)
>> +       val = readl(vt8500_chip->base + vt8500_chip->regs->en);
>> +       val |= BIT(offset);
>> +       writel(val, vt8500_chip->base + vt8500_chip->regs->en);

>BTW: have you considered [readl|writel]_relaxed?

I haven't - and to be honest I didn't know what difference it would
make until I read up on it.
Most of this code already existed in mainline in
arch/arm/mach-vt8500/gpio.c and I simply moved it across to
drivers/gpio and made some changes/additions. Having looked,
I don't see any reason why it can't use the _relaxed variants.
Changes included in v4.


I'll post up v4 for review when I get home in about 7 hours.

Work always gets in the way of being productive :)


Regards

Tony Prisk