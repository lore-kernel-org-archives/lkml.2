Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab0KRQFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:05:33 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:12333
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759303Ab0KRQFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:05:32 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h637h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4CE54E40.9040503@freescale.com>
Date: Thu, 18 Nov 2010 10:03:12 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <4CE44B1B.9040709@freescale.com> <20101117215147.GA26792@suse.de> <4CE452CD.3050001@freescale.com> <20101117221903.GA4066@suse.de> <4CE45A4E.70308@freescale.com> <20101118022434.GA9833@suse.de> <4CE546C5.8060401@freescale.com> <20101118153912.GA1443@suse.de>
In-Reply-To: <20101118153912.GA1443@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 16:04:15.0731 (UTC) FILETIME=[3FBBB430:01CB873A]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> > 
>> > I'm still not sure why you think I have a bus.  I don't see where the UART
>> > drivers register a bus, and there's not a whole lot different between a byte
>> > channel and a UART.

> But they are obviously two different things, right?

Well, sure.  A byte channel is just a software concept.  You can send data,
receive data, and poll a byte channel.  You can't set the baud rate, or send
break signals or even do flow control.  I debated making the driver act like a
fake serial device, which probably would have been easier but not "correct".

Unfortunately, I seem to lack some fundamental understanding of tty drivers that
is making my life difficult.  I've been reading all the documentation that I can
get my hands on, as well as studying a lot of source code, but I still can't
find any example to base *my* code on.  I just don't know if what I'm doing is
right.

I still don't know how to connect the byte channel handle with the /dev entry.
That's the question my original post asked, and I still don't have an answer to it.

> Why not?  It sounds like there should be, right?  That would make things
> much easier for you in the end from what I can tell.

I'm not so sure.  Like I said, I still don't see where there's a bus.  I have a
single driver that has multiple devices.  It sounds to me like one call to
tty_register_driver() and multiple calls to tty_register_device() would be
sufficient.

For instance, there is no code in drivers/char/ that makes a call to
bus_register(), so I don't see any precedent for a tty driver to register a bus
first.

Also, this is an Open Firmware driver.  I already have a mechanism whereby I get
probed for each instance of a byte channel.  Isn't that my "bus"?

I'm really trying to do the right thing here, Greg, but every time I try to
solve one problem, I'm being told that I need to make things way more
complicated first.

-- 
Timur Tabi
Linux kernel developer at Freescale

