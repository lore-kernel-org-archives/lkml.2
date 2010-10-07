Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0JGUqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:46:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36640 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab0JGUqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:46:53 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jirislaby@gmail.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Date: Fri, 8 Oct 2010 02:16:35 +0530
Subject: RE: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Topic: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Index: ActmXvZBOJpBPBAHT1CxBn10+F2b0wAAGx5w
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D24F@dbde02.ent.ti.com>
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
	<1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
	<4CACD234.7020900@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21CEA1@dbde02.ent.ti.com>
	<4CACF5A7.3010601@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21CEC6@dbde02.ent.ti.com>
	<4CAD7DAB.8030209@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21D193@dbde02.ent.ti.com>
	<4CAE10C0.9000106@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21D220@dbde02.ent.ti.com>
	<20101007203801.1c55a1d3@lxorguk.ukuu.org.uk>
	<19F8576C6E063C45BE387C64729E739404AA21D23B@dbde02.ent.ti.com>
	<20101007213503.657bcab0@lxorguk.ukuu.org.uk>
	<19F8576C6E063C45BE387C64729E739404AA21D248@dbde02.ent.ti.com>
 <20101007215943.45365f45@lxorguk.ukuu.org.uk>
In-Reply-To: <20101007215943.45365f45@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Thursday, October 07, 2010 4:00 PM
> To: Savoy, Pavan
> Cc: Jiri Slaby; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-bluetooth@vger.kernel.org
> Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
> 
> > But, I want to attach my data not when ldsic is opened, but when ldisc is
> registered.
> > I want to begin accessing the data when ldisc is opened.
> 
> How can you attach per tty data when the ldisc is registered - the
> relevant tty driver might not even have been loaded at that point. The
> user may not even have been to the shop and bought it even !
> 
> What sort of data is this ?

Data related to requesting the user-space to open/install the ldisc.
Imagine a UEVENT structure or PID of the user-space process to which I need
to send a signal .. I currently use rfkill.

> > to be like a bunch of helpers (1 for FM, 1 for GPS, 1 for NFC, 1 for power-
> management), also the problem of who owns the /dev/tty begins to occur,
> Bluetooth has a utility called hciattach, I don't want my FM radio software to
> run hciattach when /dev/radio0 is opened and communicated via FM.
> 
> I would have assumed the hotplug script would have run your own attach
> and daemon and the FM radio etc would talk to the ldisc via other kernel
> interfaces it presented.
> 
> So whenever the hardware is detected it would load the hardware driver
> The hardware driver would create a tty instance for each physical port
> The hotplug user space would run 'ti-st-attach' as a helper which would
> load the ldisc and set up the bluetooth as well as providing exported
> methods for FM radio etc.

Yes, pretty similar to what I am doing now. I have this daemon which waits
for events from my ldisc driver, and on receiving the notification it
opens the uart, ioctl's the TIOCSETD and allows the tty to be accessed over
the ldisc.

> > In any case, the ti-st/ seems better now by look of things, I certainly
> welcome suggestions to improve it.
> > Also, is there any plan to re-write whole of TTY like a the i2C or the SPI
> bus structure?
> >
> > Here I can imagine, all TTY line disciplines being sort of protocol/client
> drivers, the TTY sub-system in itself would be like the algos driver and then
> > The uart drivers (like 8250.c) can be the adapter drivers.. What say?
> 
> They already are, with the one oddity being that something needs to have
> it opened from user space and to attach the ldisc. Thats fixable but hard
> to fix and I'm not aware of any plan to do so - mostly because nobody
> needs it so far.

Yes, that oddity was the reason this notification had to be done.
I could as well have opened it up on boot and attached the ldisc, but I chose
to use it whenever other drivers wanted to - as in when hci0 is UP, or /dev/radio0 is opened.

> Alan
