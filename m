Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab0LUMFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 07:05:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab0LUMF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 07:05:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6 v9] ARM: Add basic architecture support for VIA/WonderMedia 85xx SoC's
Date: Tue, 21 Dec 2010 13:05:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-next-20101220+; KDE/4.5.1; x86_64; ; )
Cc: Alexey Charkov <alchark@gmail.com>, Ryan Mallon <ryan@bluewatersys.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <4D1011CF.9080800@bluewatersys.com> <AANLkTi=7O-HwQRcybnLSt+r+A64g=D7rZY7NbdEMFys3@mail.gmail.com>
In-Reply-To: <AANLkTi=7O-HwQRcybnLSt+r+A64g=D7rZY7NbdEMFys3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012211305.06344.arnd@arndb.de>
X-Provags-ID: V02:K0:TsJTfHCBsznE5CYI+guvLT3zbufGfG8AsAU96YIcNG9
 j7ebLMjKaHybjZt27zY+puXm9VYPUJ67v0Gk/tRT70H2YkZLMp
 +OhhyAMKG05B3thmL5erUtQ9aMsVVv7I2xt4sk3W+ZyIMehhET
 +vNpaS4bCTZ3Jb1f/JlS/D4L8l2XjOEioFFCb6tSB/kVB6JIe2
 W71t3jAOCm5wogJKKg4WA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 December 2010 11:00:43 Alexey Charkov wrote:
> #define WMT_IRQ_RES(__irq) \
> {\
>         .flags = IORESOURCE_IRQ,\
>         .start = __irq,\
>         .end = __irq,\
> }
> 
> void __init wmt_set_resources(void)
> {
>      resources_lcdc[0] = WMT_MMIO_RES(wmt_current_regs->lcdc, SZ_1K);
>      resources_lcdc[1] = WMT_IRQ_RES(wmt_current_irqs->lcdc);
> ...
> }
> 
> Then there will be no half-empty initializations scattered around
> separate from the other assignments (which is probably the worst thing
> in current configuration).

If you use platform_device_add_resources() to add the resource
at a later point, or platform_device_register_simple, you don't
even need to statically allocate the resource structure, which may
also make this simpler because you can keep all the data structures
local to the function filling them out.

	Arnd
