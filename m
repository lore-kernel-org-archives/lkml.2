Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0CXQiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:38:11 -0400
Received: from senator.holtmann.net ([87.106.208.187]:53415 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab0CXQiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:38:10 -0400
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
From: Marcel Holtmann <marcel@holtmann.org>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Greg KH <gregkh@suse.de>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <12213.61465.qm@web94909.mail.in2.yahoo.com>
References: <12213.61465.qm@web94909.mail.in2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 09:38:00 -0700
Message-ID: <1269448680.11714.121.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

> > > I wanted to somehow put this in staging because then
> > it would probably have a thorough architectural review
> > process.
> > > Some details about this driver - 
> > > 
> > > 1. This driver will be used by Bluetooth-BlueZ/FM-V4L2
> > and GPS (probably character device driver) using the
> > EXPORTED symbols (-register/_unregister).
> > > 
> > > 2. Much like the hciattach daemon which maintains
> > N_HCI bluetooth line discipline, this driver will also have
> > a User-Space  N_TI_WL Init manager (UIM) maintaining
> > the Line discipline.
> > 
> > can you explain why you think this is needed and we can not
> > interface
> > this directly. If it is a serial port, what protocol does
> > it talk?
> 
> Illustration: The BT driver on top of this ST driver, would create a hci0 interface, when someone does an DEVUP on that interface, the BT driver would then do a st-register - which in-turn would ask the hciattach-like daemon to install the line discipline for it via the sysfs entry.
> The same concept goes for FM-V4L2 and GPS character driver.
> 
> The core of the problem is we cannot ask/install/ldisc_put for a line discipline from kernel space.

so let us get the facts straight here. The device in question is using a
serial port to connect to the host and then multiplexing BT, FM and GPS
over it. My question again, what protocol does it talk.

Also why not just install the line discipline and then control the
subdevices via RFKILL?

You need to share some information about your hardware with us that
explain what are your objections and how it works.

> > > 3. Because of the UIM should know when to
> > install/uninstall line discipline, the /sys entry is created
> > a root called UIM (a new kobject) and UIM daemon would write
> > it's PID to it.
> > 
> > I don't understand this. This sounds like a broken concept
> > to me.
> 
> Yes, I don't feel good about it either. But how do I request for a line discipline from kernel space ?
> Currently a daemon has to run in user-space to maintain the ldisc, at all times, and I don't want to open TTY @ boot, and install Ldisc (tiocsetd) on it, without BT/FM or GPS core on chip being used - The Power Management team here would beat me up if I do that, 
> and hence the very dumb idea of passing the PID of the daemon via sysfs entry, and the driver sending SIGUSR2 to that PID, daemon doing a tiocsetd upon that signal.

Lets forget about this at all. This is not working out at all. We need
to figure out a workable solution.

> > > 4. As Alan suggested, If I make it self-contained by
> > pushing number of line disciplines to a slightly larger
> > number, then would it be OK ?
> > 
> > Just from a quick look, I think within a few review cycles
> > this might be
> > able to get proper upstream inclusion. No idea why bother
> > with staging
> > in the first place. Lets do this correctly.
> > 
> 
> The only reason I wanted this to be in staging was to have sort of continuous review process, and in hope the driver wouldn't be forgotten.

I dislike using the staging tree as review process. We can make a proper
review on LKML and go towards a real upstream solution.

Regards

Marcel


