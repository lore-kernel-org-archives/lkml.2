Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0KBOXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:23:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37685 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0KBOXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fwwp6PyMuJCfx1f8PhvInrgD8xP+ONNa3mJfiyHP61YEeRLb8DJFoLCm1pA2mbg3Hx
         ppr06qILM2fETgy1Vk6HmsRbZPHhezUkqVwCCLY8oLsVUffF4Pfnqcv2M4YJ3YT/3HE5
         PthabHc0aA4V4jEgULgFfxdHn27sdShWOnX6Q=
MIME-Version: 1.0
In-Reply-To: <20101102141456.GV31158@pengutronix.de>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
	<1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
	<20101102141456.GV31158@pengutronix.de>
Date: Tue, 2 Nov 2010 16:23:22 +0200
Message-ID: <AANLkTi=4hi-zNSFPvHnTEPeweTuqUwni+Aij_E6Zj8i5@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>, Mike Rapoport <mike@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/2 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> On Tue, Nov 02, 2010 at 02:14:13AM +0200, Felipe Contreras wrote:
>> Add missing dependencies, and remove redundant ones, and select sensible
>> defaults.
>>
>> This is more user-friendly, and logical.
>>
>>  - TWL4030_CORE people should be able to compile without ARM
>>  - REGULATOR_TWL4030 if TWL4030_CORE and REGULATOR, it's pretty clear we
>>    want this
>>  - USB_GADGET_SELECTED is already inside USB_GADGET
>>  - USB_GADGET_OMAP only works on ARCH_OMAP1, and USB_OTG_UTILS is
>>    already selected by NOP_USB_XCEIV
>>  - USB_GADGET_R8A66597 is meant for ARCH_SHMOBILE
>>  - USB_MUSB_HDRC needs either NOP_USB_XCEIV, or TWL4030_USB
>>  - USB_MUSB_AM35X, NOP_USB_XCEIV is already selected because MACH_OMAP3EVM
>>
>> Finally, move:
>> config USB_MUSB_HDRC
>>       select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
>>       select TWL4030_USB if MACH_OMAP_3430SDP
>>
>> To:
>> config TWL4030_USB
>>       default y if ARCH_OMAP3
>>
>> config NOP_USB_XCEIV
>>       default y if ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> All changes look fine to me, but I think you will need to split up this
> patch for the different subsystem maintainers.

Ok, will do.

-- 
Felipe Contreras
