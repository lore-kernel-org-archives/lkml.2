Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750Ab2KBLQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 07:16:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35955 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762691Ab2KBLQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 07:16:11 -0400
Date: Fri, 2 Nov 2012 11:21:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russ Dill <Russ.Dill@ti.com>
Cc: balbi@ti.com, Pantelis Antoniou <panto@antoniou-consulting.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121102112104.4657fb7b@pyramind.ukuu.org.uk>
In-Reply-To: <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
References: <50924DA3.1060901@ti.com>
	<F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
	<20121101110418.GF410@arwen.pp.htv.fi>
	<3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
	<20121101124025.GA12489@arwen.pp.htv.fi>
	<A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
	<20121101131609.GC12489@arwen.pp.htv.fi>
	<E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
	<20121101135148.382aec00@pyramind.ukuu.org.uk>
	<9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
	<20121101220518.GE14982@arwen.pp.htv.fi>
	<CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Fair enough. But there's no such thing a 'hotplug enumeration
> >> construct' in Linux yet, and a bus is the closest thing to it. It does
> >> take advantage of the nice way device code matches drivers and devices
> >> though.

A bus is the wrong construct. You need something to add devices onto the
busses. You can do that. The Intel SFI layer on phones for example
enumerates devices through a firmware table set and creates them on the
right actual physical bus not on their own fake one.

It's not hotplug in the sense that the phone happens be a fixed
configuration but it does support hotplug behaviour because the order of
the drivers and enumeration is undefined (and both orders work).

> >>
> >> I'm afraid that having the I2C/SPI drivers doing the detection won't
> >> work.  The capes can have arbitrary I2C/SPI devices (and even more
> >> weird components).  There is no way to assure for example that the I2C
> >> device responding to address 'foo' in cape A is the same I2C device
> >> responding to the same address in cape B.
> >
> > your ->detect() method should take care of that.
> 
> There isn't some magical serial number in I²C devices that a
> ->detect() method can read and the implementation of I²C is somewhat

It doesn't matter.

What you are basically talking about is


	cape layer
		- wtf is this
		- how do I plumb it

		- create device nodes with correct name for
		  binding, address etc on the right bus


	i2c layer
		- ooh a new i2c device
		- probe as indicated by device name
		- attach correct driver


Architecturally its possible you want to make some caps MFDs if they have
their own bus heirarchies etc but generally I doubt it.


Take a look at arch/x86/platform/mrst/mrst.c. It's a specific example of
a platform which parses tables and attaches devices to the right physical
bus in a manner they can be reliably probed even when the device has no
sane autodetect.

Alan
