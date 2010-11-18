Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab0KRRXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:23:08 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:46991
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932576Ab0KRRXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:23:06 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzz8275bhz2dh2a8h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Date: Thu, 18 Nov 2010 11:21:46 -0600
From: Scott Wood <scottwood@freescale.com>
To: Timur Tabi <timur@freescale.com>
CC: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118112146.3275eb08@udp111988uds.am.freescale.net>
In-Reply-To: <4CE54E40.9040503@freescale.com>
References: <4CE44B1B.9040709@freescale.com>
	<20101117215147.GA26792@suse.de>
	<4CE452CD.3050001@freescale.com>
	<20101117221903.GA4066@suse.de>
	<4CE45A4E.70308@freescale.com>
	<20101118022434.GA9833@suse.de>
	<4CE546C5.8060401@freescale.com>
	<20101118153912.GA1443@suse.de>
	<4CE54E40.9040503@freescale.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 17:22:49.0844 (UTC) FILETIME=[39904340:01CB8745]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 10:03:12 -0600
Timur Tabi <timur@freescale.com> wrote:

> I'm not so sure.  Like I said, I still don't see where there's a bus.  I have a
> single driver that has multiple devices.  It sounds to me like one call to
> tty_register_driver() and multiple calls to tty_register_device() would be
> sufficient.
> 
> For instance, there is no code in drivers/char/ that makes a call to
> bus_register(), so I don't see any precedent for a tty driver to register a bus
> first.

The tty driver doesn't register the bus, but rather a driver for
some type of device on that bus.  The code to create the bus goes
elsewhere, and would not be specific to byte channels.

> Also, this is an Open Firmware driver.  I already have a mechanism whereby I get
> probed for each instance of a byte channel.  Isn't that my "bus"?

It would be if you actually had it -- but it looks like you just loop
over the nodes.

We should add a proper bus for the "handles" node.  Then sysfs should
show the link between the tty device and a device tree node -- which is
really what we're after, the handle is just a means to that end.

> I'm really trying to do the right thing here, Greg, but every time I try to
> solve one problem, I'm being told that I need to make things way more
> complicated first.

s/make things way more complicated/use the existing infrastructure
rather than reinvent the wheel/

And getting rid of the redundant chardev driver would be a
simplification...

-Scott

