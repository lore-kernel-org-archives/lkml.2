Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934593Ab2J3VvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:51:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64555 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab2J3VvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:51:13 -0400
MIME-Version: 1.0
In-Reply-To: <20121030183704.GX4511@opensource.wolfsonmicro.com>
References: <20121025205901.GA3827@sirena.org.uk>
	<20121026062008.GA21734@arwen.pp.htv.fi>
	<20121026160316.GY18814@opensource.wolfsonmicro.com>
	<20121029194901.GA30152@arwen.pp.htv.fi>
	<20121030112410.GM4511@opensource.wolfsonmicro.com>
	<20121030114949.GC28722@arwen.pp.htv.fi>
	<20121030140714.GO4511@opensource.wolfsonmicro.com>
	<20121030151642.GE29159@arwen.pp.htv.fi>
	<20121030155821.GU4511@opensource.wolfsonmicro.com>
	<20121030172513.GA3993@arwen.pp.htv.fi>
	<20121030183704.GX4511@opensource.wolfsonmicro.com>
Date: Tue, 30 Oct 2012 22:51:11 +0100
Message-ID: <CACRpkdac=ztY0vXQ8Mu6H8fiAO4aFSSF-A6O1Q==zKOKEsJegw@mail.gmail.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 7:37 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> More seriously the amount of time we seem to have been spending recently
> on changes which end up requiring us to go through essentially every
> driver and add code to them (often several times) doesn't seem like
> we're doing a good job here.

If this is your main concern you should be made aware that there
are people out there planning to supplant the existing DT probe paths
that are now being added to each and every ARM-related driver
with an ACPI probe path as ARM servers come into the picture.

> pinctrl is really noticable because it's
> new but it's not the only thing.  As a subsystem maintainer this code
> just makes me want to add new subsystem features to pull the code out of
> drivers but obviously that's not something that should be being done at
> the subsystem level.

We did manage to drag the power/voltage domain per se out
of the AMBA bus, and recommend that people (like us) do that
business using the power domains.

I think most people (including OMAP) have bought
into the concept of using the runtime PM framework and power
domains to control the power domain switches.

It's this wider concept of using the loose concept "PM resource
domains" to control also clocks and pins that is at stake, and so
far the runtime PM core people (Rafael and Magnus) has not said
much so I think we need some kind of indication from them as to
what is to happen, long-term, with drivers handling their own clocks
and pins. Should it be centralized or not? If it's to be centralized it
needs to become a large piece of infrastructure refactoring and
needs the attention of Linaro and the like to happen.

I've CC:ed a few people into this thread so we get some traction,
we need more subsystem maintainers in here.

Yours,
Linus Walleij
