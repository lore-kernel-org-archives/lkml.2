Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0FUWb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:31:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32887 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752566Ab0FUWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:31:58 -0400
Date: Mon, 21 Jun 2010 18:31:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@tikei.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Suspend hangs since 2.6.34
In-Reply-To: <20100621213224.GA5723@mac.home>
Message-ID: <Pine.LNX.4.44L0.1006211828090.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Tino Keitel wrote:

> On Mon, Jun 21, 2010 at 21:24:08 +0200, Rafael J. Wysocki wrote:
> > On Monday, June 21, 2010, Tino Keitel wrote:
> > > Hi,
> > > 
> > > this nasty bug did not appear after I enabled suspend debugging first,
> > > but now it did:
> > > 
> > > 2010-06-20_22:40:31.22927 kern.info: usbcore: deregistering interface driver dvb_usb_vp7045
> > > 2010-06-20_22:40:31.24960 kern.debug: usb 1-6: __pm_runtime_resume()!
> > > 2010-06-20_22:40:31.24968 kern.debug: usb 1-6: __pm_runtime_resume() returns 1!
> > > 2010-06-20_22:40:31.24969 kern.debug: PM: Removing info for No Bus:dvb0.frontend0
> > > 2010-06-20_22:40:31.24971 kern.debug: PM: Removing info for No Bus:dvb0.net0
> > > 2010-06-20_22:40:31.24972 kern.debug: PM: Removing info for No Bus:dvb0.demux0
> > > 2010-06-20_22:40:31.24973 kern.debug: PM: Removing info for No Bus:dvb0.dvr0
> > > 2010-06-20_22:40:31.24974 kern.info: dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfully deinitialized and disconnected.
> > > 2010-06-20_22:40:32.26675 kern.info: PM: Syncing filesystems ... done.
> > > 2010-06-20_22:40:32.39011 kern.debug: PM: Preparing system for mem sleep
> > > 
> > > When I killed the suspend script which hung at the echo mem >
> > > /sys/power/state line, the computer suspended. After wakeup, the kernel
> > >  log lines after the line above look like this:
> > > 
> > > 2010-06-20_22:49:10.28745 kern.warn: Freezing user space processes ... (elapsed 0.02 seconds) done.
> > > 2010-06-20_22:49:10.28748 kern.warn: Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> > > 2010-06-20_22:49:10.28748 kern.debug: PM: Entering mem sleep
> > > 2010-06-20_22:49:10.28749 kern.warn: Suspending console(s) (use no_console_suspend to debug)
> > > 
> > > I also attached the full kernel log since the boot.
> > 
> > Hmm.  It looks like a USB problem, then.
> 
> Just FYI: The dvb-usb message is generated when the driver for the
> DVB-T USB receiver is unloaded. I unload it because I had issues after
> resume if I did not unload it.

Why does this look like a USB problem?  As far as I can tell, the bug 
is that the system delays somewhere during the suspend procedure.  But 
there's no reason to think the delay is connected with USB.

If you boot with "no_console_suspend" on the boot command line and set
the console loglevel high enough to see all messages, can you tell at
what point the hang occurs?  I didn't see any clues when looking at the
timestamps in the full kernel log.

Alan Stern

