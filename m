Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab0LFH3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 02:29:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33628 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab0LFH3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 02:29:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 6 Dec 2010 08:29:18 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Robin Cook <rcook@wyrms.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
        linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: Issue with firewire from 2.6.35.9 to 2.6.36.1
Message-ID: <20101206082918.6d1ccc41@stein>
In-Reply-To: <1291594279.9196.2.camel@maxim-laptop>
References: <1291592226.7134.1.camel@pheuri.wyrms.net>
	<1291594279.9196.2.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 2010-12-05 at 17:37 -0600, Robin Cook wrote:
> > Hello,
> > 
> > I recently upgraded from 26.35.9 to 2.6.36.1 and now the /dev/fwX
> > devices are not being created.  I have udev 164 installed.
> > 
> > 2.6.35.9 dmesg firewire lines...
> > 
> > firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
> > firewire_ohci 0000:07:00.0: setting latency timer to 64
> > firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x1
> > firewire_core: created device fw0: GUID 0010dc0001adc862, S400
> > firewire_core: created device fw1: GUID 00808803072803a5, S100
> > firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> > 
> > 2.6.36.1 dmesg firewire lines...
> > 
> > firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
> > firewire_ohci 0000:07:00.0: setting latency timer to 64
> > firewire_ohci 0000:07:00.0: irq 75 for MSI/MSI-X
> > firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x1
> > 
> > I have compared the difference between the two kernel configs and the
> > only differences that I see that may apply to the firewire are:
> > 
> >  CONFIG_DNOTIFY=y
> > -CONFIG_INOTIFY=y
> >  CONFIG_INOTIFY_USER=y
> > 
> >  # CONFIG_IEEE1394 is not set 
> > +CONFIG_FIREWIRE_NOSY=m  
> >  CONFIG_I2O=m
> > 
> > On the ieee1394 wiki page it says that these kernel option are expected
> > to be on for the libraw1394:
> > 
> > CONFIG_INOTIFY=y
> > CONFIG_INOTIFY_USER=y
> > CONFIG_EPOLL=y
> > 
> > These option are correct in the 2.6.35.9 kernel but the CONFIG_INOTIFY
> > option is missing completely in the 2.6.36.1 kernel.
> > 
> > Is this a change in how the firewire works in the kernel and that udev
> > needs to be modified or is there something else wrong?

I hadn't noticed that the INOTIFY kconfig options changed relative to
what is documented at the wiki.  I'll update that.

It is most likely not the cause for your issue.  Rather, MSI support
(messages signaled interrupts, added to firewire-ohci in kernel 2.6.36)
of your controller might be buggy.  Which controller do you have
according to "lspci -nn"?

Try "modprobe -r firewire-ohci", "modprobe firewire-ohci quirks=17".
The unrelated quirks flag 1 is already present in firewire-ohci's
quirks list; the additional flag 16 switches off MSI.
-- 
Stefan Richter
-=====-==-=- ==-- --==-
http://arcgraph.de/sr/
