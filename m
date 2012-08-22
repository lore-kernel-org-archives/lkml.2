Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2HVLzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:55:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42504 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2HVLza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:55:30 -0400
Date: Wed, 22 Aug 2012 12:55:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120822115524.GA18545@gmail.com>
References: <20120820164949.GB22749@gmail.com>
 <20120820175155.GH26991@opensource.wolfsonmicro.com>
 <20120821085618.GA26899@gmail.com>
 <20120821095026.GU26991@opensource.wolfsonmicro.com>
 <20120821105413.GD26899@gmail.com>
 <20120821110329.GA7995@opensource.wolfsonmicro.com>
 <20120821120243.GF26899@gmail.com>
 <20120821165207.GX7995@opensource.wolfsonmicro.com>
 <20120822081746.GA4089@gmail.com>
 <20120822111913.GG7995@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120822111913.GG7995@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I made the suggestion then later on realised that this was actively
> > > going to break things I care about so I actually need it fixing.
> 
> > I'm a little taken aback and annoyed by this. In a previous email thread
> > you categorically requested that I discuss some of the important changes
> > with maintainers and people in-the-know prior to actually writing any
> > code.
> 
> No, that's not something I've ever said to do.
> 
> I *have* asked you to communicate more clearly about what you're doing
> but that doesn't mean to stop sending code, it means to have clearer
> words around what you're sending. 

That's not how I interpreted your words:

"What you can do here is to commmunicate about what you're doing more.
Don't just think about the code, think about the communication
surrounding the code - this is the core of the issue."

> The really bad pattern here is that
> you're frequently working around issues in your drivers with changes in
> the subsystem without mentioning that the driver issues even exist -
> this makes it much harder understand what you are trying to achieve,
> especially when there is a problem with your subsystem changes and/or
> the urgency you're attaching to them.

Frequently? I've done this once, and yes I did push hard because I
thought the subsystem was incorrect (I still think folding an entire
driver because of a minor failure is wrong, but we digress).

This is completely different to that. This was a subsystem change
designed to aid DT enabled MFDs which 'chose' to register themselves
in a specific way, by passing their compatible string through the 
mfd_cell only. It doesn't affect any other MFD unless they wrongly
assume the conversion would be automatically done for them. However,
the author would know because they would have tested it. All of this
was discussed at length with Arnd and this is what we came up with. 

I think it's great that you like the idea and want to extend that
functionality to other MFDs which perhaps don't support DT, or the
ones that do but don't want to provide compatible strings or device
nodes for all the MFD's child devices. But that is all we're doing
here. There was no breakage. It served a purpose and it worked well.
So well in fact that you've now provided the intended functionality
to other devices.

> >       I was obviously actively working on, had put time into, and was in
> > the mist of discussing this with you. Then you just go ahead and code it
> > (the easy part) yourself, essentially wasting my time. Surely there's
> > some kind of etiquette surrounding such things?
> 
> To be honest in this case I had expected to send the patch out much
> sooner than I did - several priority interrupts stopped me testing it.
> Like I say I realised that I really needed a fix and it seemed like the
> quickest way to accomplish that was to just send the code.

You only noticed it 2 days ago and I had a patch ready to go yesterday.
I'm confused because I don't understand why would you even complain about
it if you intended to work on it yourself? Surely, "Ah, I see an issue with
xyz, patch to follow." Would have been more appropriate, instead of 
complaining about it, then I go and waste my time trying to fix something
you intend on fixing yourself.

I guess what's done is done now.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
