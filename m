Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab0KRRm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:42:27 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25767
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755489Ab0KRRmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:42:25 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h637h668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Message-ID: <4CE5657D.8060105@freescale.com>
Date: Thu, 18 Nov 2010 11:42:21 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <4CE44B1B.9040709@freescale.com>	<20101117215147.GA26792@suse.de>	<4CE452CD.3050001@freescale.com>	<20101117221903.GA4066@suse.de>	<4CE45A4E.70308@freescale.com>	<20101118022434.GA9833@suse.de>	<4CE546C5.8060401@freescale.com>	<20101118153912.GA1443@suse.de>	<4CE54E40.9040503@freescale.com> <20101118112146.3275eb08@udp111988uds.am.freescale.net>
In-Reply-To: <20101118112146.3275eb08@udp111988uds.am.freescale.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 17:43:23.0836 (UTC) FILETIME=[19147FC0:01CB8748]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:

> The tty driver doesn't register the bus, but rather a driver for
> some type of device on that bus.  The code to create the bus goes
> elsewhere, and would not be specific to byte channels.

Which code to create the bus?  Are you saying that the driver should call
bus_register()?

>> Also, this is an Open Firmware driver.  I already have a mechanism whereby I get
>> probed for each instance of a byte channel.  Isn't that my "bus"?
> 
> It would be if you actually had it -- but it looks like you just loop
> over the nodes.

Well, ok, but I can change that.  If I drop the normal character driver
registration and register the byte channels only as tty devices, then I can make
it probe-able.  The reason I don't do it now is because, for a normal character
device, I need to call cdev_init() and cdev_add() after all devices have been
registered, which can't be done in an OF driver since I don't get told when
there are no more probes.

> We should add a proper bus for the "handles" node.  Then sysfs should
> show the link between the tty device and a device tree node -- which is
> really what we're after, the handle is just a means to that end.

How exactly do I do that?

> And getting rid of the redundant chardev driver would be a
> simplification...

I agree there, but so far people have been telling me, "just do this!" without
actually telling me how to do "this".


-- 
Timur Tabi
Linux kernel developer at Freescale

