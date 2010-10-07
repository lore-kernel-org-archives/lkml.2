Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0JGUd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:33:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53470 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753883Ab0JGUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:33:54 -0400
Date: Thu, 7 Oct 2010 21:59:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Message-ID: <20101007215943.45365f45@lxorguk.ukuu.org.uk>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21D248@dbde02.ent.ti.com>
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
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But, I want to attach my data not when ldsic is opened, but when ldisc is registered.
> I want to begin accessing the data when ldisc is opened.

How can you attach per tty data when the ldisc is registered - the
relevant tty driver might not even have been loaded at that point. The
user may not even have been to the shop and bought it even !

What sort of data is this ?

> to be like a bunch of helpers (1 for FM, 1 for GPS, 1 for NFC, 1 for power-management), also the problem of who owns the /dev/tty begins to occur, Bluetooth has a utility called hciattach, I don't want my FM radio software to run hciattach when /dev/radio0 is opened and communicated via FM.

I would have assumed the hotplug script would have run your own attach
and daemon and the FM radio etc would talk to the ldisc via other kernel
interfaces it presented.

So whenever the hardware is detected it would load the hardware driver
The hardware driver would create a tty instance for each physical port
The hotplug user space would run 'ti-st-attach' as a helper which would
load the ldisc and set up the bluetooth as well as providing exported
methods for FM radio etc.

> In any case, the ti-st/ seems better now by look of things, I certainly welcome suggestions to improve it.
> Also, is there any plan to re-write whole of TTY like a the i2C or the SPI bus structure?
> 
> Here I can imagine, all TTY line disciplines being sort of protocol/client drivers, the TTY sub-system in itself would be like the algos driver and then
> The uart drivers (like 8250.c) can be the adapter drivers.. What say?

They already are, with the one oddity being that something needs to have
it opened from user space and to attach the ldisc. Thats fixable but hard
to fix and I'm not aware of any plan to do so - mostly because nobody
needs it so far.

Alan
