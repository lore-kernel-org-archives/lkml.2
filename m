Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817Ab2KBQXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:23:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36420 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863Ab2KBQXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:23:32 -0400
Date: Fri, 2 Nov 2012 16:28:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Kridner <jkridner@beagleboard.org>
Cc: Russ Dill <Russ.Dill@ti.com>, balbi@ti.com,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121102162824.3dc3d535@pyramind.ukuu.org.uk>
In-Reply-To: <CA+T6QPkWLXx6-Bh-4VdsdoHypHNkJ4hTdkk-rqUEyGEswpW6fQ@mail.gmail.com>
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
	<20121102112104.4657fb7b@pyramind.ukuu.org.uk>
	<CA+T6QPkWLXx6-Bh-4VdsdoHypHNkJ4hTdkk-rqUEyGEswpW6fQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Further, it is critical to enable hardware vendors to avoid writing
> any code for which there are existing drivers.

Which is why you don't want to create a new bus type for it.

> Capebus seems to me to provide this solution fairly well. I don't
> believe the SFI approach covers the most critical aspects of hotplug
> behaviour.

I think you missed the point - it just an example of doing this not one
I'd suggest using directly.

> >> > your ->detect() method should take care of that.
> >>
> >> There isn't some magical serial number in I²C devices that a
> >> ->detect() method can read and the implementation of I²C is somewhat
> >
> > It doesn't matter.
> >
> > What you are basically talking about is
> >
> >
> >         cape layer
> >                 - wtf is this
> >                 - how do I plumb it
> >
> >                 - create device nodes with correct name for
> >                   binding, address etc on the right bus
> >
> >
> >         i2c layer
> >                 - ooh a new i2c device
> >                 - probe as indicated by device name
> >                 - attach correct driver
> 
> Many of the devices cannot be probed.

Look more closely at the code I pointed you at. I wonder if have a
differing understanding of the word "probe" in this situation. In the
Linux space the driver bindings call the matching probe function based
upon the device structure.

In Linux the probe method does not mean "scan the bus and enumerate/detect
the devices"

If an i²c bus is thrown a device which has an address and a matching name
the only thing it will attempt to do is to call the probe method of the
device driver matching that name on the given i²c address. In other words
its a "probe" in the sense of "I've been told there is one of your
widgets here, please take a look" not a "probe" in the sense of "scan 255
i²c addresses and poke randomly at them"

SFI for example creates entries for things like

	"type foo pressure sensor at 0x68 on bus 3"

and the core kernel i²c code will only call the "foo" drivers probe method
and only on bus 3 and only for address 0x68.

In your case you want to use your DT fragments or any other descriptor
format to do exactly the same. Not create a new bus but add a bunch of
devices to the existing busses.

It's like hot plugging a PCI card - you don't create a new PCI bus, you
add a device to the existing bus. In the PCI case the device has
properties that uniquely identify it from hardware level. In the i²c case
the properties come from your DT fragment or similar. The rest is the
same.

> I know I *am* the slow person in the room, but doesn't this approach
> require the code to be compiled into the kernel to support the devices
> ahead of time? While I think it might be reasonable to have hardware

The specific implementation in SFI does but thats a property of SFI. I'm
not trying to push SFI itself anywhere except over the edge of a very tall
cliff.

The point is that you can take a description of things like i²c devices
and have then properly identified on the existing busses using the
existing bus architecture just fine.

> developers provide DT fragments in their EEPROMs, there's no way to
> get them to submit code patches in order to get their hardware to
> work. They need to ship hardware that works with pre-existing
> software, since there will be hundreds of boards created by people
> with little to no previous Linux experience (akin to Arduino). I seem
> to be missing how that approach would get us there.

That is what I assume and what I believe can be provided without
inventing imaginary bus types.

Alan
