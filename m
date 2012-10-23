Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2JWLMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:12:13 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:37096 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2JWLMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:12:10 -0400
Date: Tue, 23 Oct 2012 13:11:56 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: balbi@ti.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Magnus Damm <damm@opensource.se>, Paul Mundt <lethal@linux-sh.org>,
        Benoit Cousson <b-cousson@ti.com>, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Sourav Poddar <sourav.poddar@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121023131156.13e2d0ae@skate>
In-Reply-To: <CACRpkdZhUwMTg0suqbZiukN7Se6fzdYP3-0Dspm9WF6qZniNVQ@mail.gmail.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121022155028.GA13791@core.coreip.homeip.net>
	<CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
	<508664CA.7000601@ti.com>
	<CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
	<20121023100333.GA24418@arwen.pp.htv.fi>
	<20121023122312.56b23e1c@skate>
	<CACRpkdb+f44jw1vTYvJT0bnMOP8XQe8ztDUHiwtS2JHtPWAGXw@mail.gmail.com>
	<20121023102903.GA24820@arwen.pp.htv.fi>
	<CACRpkdZhUwMTg0suqbZiukN7Se6fzdYP3-0Dspm9WF6qZniNVQ@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 23 Oct 2012 12:45:33 +0200, Linus Walleij wrote:

> Hm so I have had this idea of runtime PM core helping out
> with pins, so I could add something like
> 
> pm_pins_fetch()
> pm_pins_default()
> pm_pins_idle()
> pm_pins_sleep()
> 
> So if one is using the pin states defined in
> <linux/pinctrl/pinctrl-state.h> then the PM core can help out in
> keeping track of the pins and states, and the driver will just tell
> the PM core what to do and when.
> 
> Would this fit the bill for everyone's code consolidation needs?
> It would sure work for us...

That surely would work but is kind of non-obvious when reading a
driver's code: that's the problem with bus notifier, they do things a
bit "behind your back" without you noticing. Having the driver request
its own pinctrl state, and switch between states upon suspend/resume is
a lot more explicit, IMO.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
