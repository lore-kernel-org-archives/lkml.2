Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422820Ab2JaNVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:21:16 -0400
Received: from mo5.mail-out.ovh.net ([178.32.228.5]:59784 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935537Ab2JaNVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:21:14 -0400
Date: Wed, 31 Oct 2012 14:19:03 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-input@vger.kernel.org,
        Sourav Poddar <sourav.poddar@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121031131903.GF19021@game.jcrosoft.org>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3091721145440447453
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -90
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrvdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddutddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucffohhmrghinhepmhgrrhgtrdhinhhfohdpohiilhgrsghsrdhorhhgnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -90
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrvdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddutddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucffohhmrghinhepmhgrrhgtrdhinhhfohdpohiilhgrsghsrdhorhhgnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:12 Sun 28 Oct     , Linus Walleij wrote:
> On Wed, Oct 24, 2012 at 7:28 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> 
> >> drivers/spi/spi-pl022.c
> >
> > Default/sleep transitions could be moved into bus code.
> 
> No that's not a good idea as long as we have both the platform bus
> and the AMBA bus doing essentially the same thing. We will then be
> having two copies of the same code in two different busses running
> out of sync. There may be other busses too.
> 
> But I could prepare static helpers in <linux/pinctrl/consumer.h>
> that any bus could use. Or any driver. Probably any driver,
> because of this:
> 
> As noted the bus cannot really execute the pinctrl calls to
> e.g. put a drivers pins into "sleep". Since if e.g. the bus is walking
> the suspend() ladder, shall it put the pins into sleep *before*
> or *after* calling the suspend() hook in the driver?
> 
> The answer is that it does not know. Because drivers have
> different needs. Depending on how the hardware and
> system is done.
> 
> I already tried to make this point:
> 
> pinctrl_set_state(state_sleep);
> clk_disable();
> power_off_voltage_domain();
> 
> May for some drivers have to be:
> 
> clk_disable();
> power_off_voltage_domain();
> pinctrl_set_state(state_sleep);
> 
> (etc)
> 
> I'm not making this up, it is a very real phenomenon on the
> Ux500 and I don't think we are unique.
I agree with Linus

you can not handle pinctrl as bus levell

as each driver need different requirement before enabling the pin

as example you may need to clock the ip before muxing the pin and invertly

on some IP the pinctrl is optionnal, on other mandatory

you can not expect every driver to have the same need and requirement

yes we will have a few code duplication

but today it's few lines and those few lines will be place at different init
stage on the drivers ditto for remove or sleep/idle


> 
> Moving this handling to bus code or anywhere else
> invariably implies that resource acquisition/release order
> does not matter, and my point is that it does.

100% agreed

Best Regards,
J.
> 
> >> drivers/i2c/busses/i2c-nomadik.c
> >
> > Don't see pinctrl in linux-next.
> 
> This code is here:
> http://marc.info/?l=linux-i2c&m=134986995731695&w=2
> 
> Yours,
> Linus Walleij
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
