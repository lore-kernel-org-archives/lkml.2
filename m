Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1I1TPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 15:15:02 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20368 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1I1TO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 15:14:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=nc+E1jPrO6t78VGoU5kyaRaqgi/sJgq0vDr/mr8SPeFrFHH4T1dc0YZ71jvhSi93J
	pnktsmiPqKREH3sXbj3Yg==
MIME-Version: 1.0
In-Reply-To: <4E835EBC.3080604@linux.intel.com>
References: <4E820FA8.8050604@linux.intel.com> <20110927225722.54936878@lxorguk.ukuu.org.uk>
 <4E835EBC.3080604@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 28 Sep 2011 13:14:35 -0600
Message-ID: <CAErSpo6XcctMq1uM2No8Z=1_sgBxBhNQ3os3dU=aHCsPxrpwBg@mail.gmail.com>
Subject: Re: Serial issues with EG20T (Topcliff) PCH uarts
To: Darren Hart <dvhart@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "lkml," <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis@compulab.co.il>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:51 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>
> Hi Alan,
>
> Thanks for the suggestions. Still not working, details follow.
>
> On 09/27/2011 02:57 PM, Alan Cox wrote:
> >> Using the ti_usb_3410_5052 driver with modified vendor/product strings, I am
> >> able to get ttyUSB0 on my host and open it in minicom:
> >>
> >> $ sudo modprobe ti_usb_3410_5052 vendor_3410=0x0451 product_3410=0x5053
> >> $ minicom -D /dev/ttyUSB0
> >
> > Please submit those idents to GregKH for the ti_usb driver.
> >
>
> I will. I need to confirm this is something I can do now (if I can use
> the product name, etc.).
>
> >> Can anyone offer up some ideas on what I might try to get:
> >>
> >> 1) the getty working
> >> 2) the earlier kernel messages to appear
> >> 3) syslinux working
> >>
> >> over the serial port?
> >
> > It may depend a lot on the port. If it boots in PCI D3 (power saved) then
> > it's going to be fun. Otherwise forcing the address of the port ought to
> > do the trick.
> >
> > See
> >       console=uart8250,io 0xb060,115200n8
>
> I tried:
>
> console=uart8250,io,0xb060,115200n8
>
> With this I got 4 non-ascii chars
>
> >
> > although it's polled so you may want to drop the speed a bit!
>
> I switched all my terminal emulators, syslinux config, the getty, and
> console redirection in the bios to use 9600n8. Then ran with:
>
> console=uart8250,io,0xb060,9600n8
>
> This printed several bursts of garbled non-ascii strings, but did so
> very early! :)
>
> With minicom on each end, I see the INT 18 count go up by 1 for every
> char sent from the board and up by 3 for every char sent from my dev
> box, as well as the irregular rx,fe increment mentioned originally.
>
> >
> > netconsole might also be useful to debug the early serial problems !
>
> I did give that a shot, it complained about eth0 not existing, despite
> the driver being compiled in. Possibly an init race with netconsole and
> pch_gbe? Similar posts sent to linux-next earlier this year.
>
>
> >
> > No idea for syslinux.
>
> Doesn't like 9600 either.

Are you using "serial 1" or similar for the syslinux config?  I don't
know how syslinux learns the (port -> address) mapping, but
doc/syslinux.txt says you can also specify the address directly, e.g.,
"serial 0xb060 9600".

I'm not familiar with the EG20T hardware, but all the code in
drivers/tty/serial/pch_uart.c makes me wonder how 16550-compatible
those things really are.  If the EG20T UARTs require special tickling,
syslinux isn't likely to know how to do that.

Bjorn
