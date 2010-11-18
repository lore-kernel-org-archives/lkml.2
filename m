Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab0KRR71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:59:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab0KRR70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:59:26 -0500
Date: Thu, 18 Nov 2010 09:58:32 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118175832.GA4931@suse.de>
References: <20101118022434.GA9833@suse.de>
 <4CE546C5.8060401@freescale.com>
 <20101118153912.GA1443@suse.de>
 <4CE54E40.9040503@freescale.com>
 <20101118163321.GA2723@suse.de>
 <4CE5562B.8080604@freescale.com>
 <20101118165136.GA3103@suse.de>
 <4CE55ACB.80207@freescale.com>
 <20101118171856.GA4283@suse.de>
 <4CE5647F.5000203@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE5647F.5000203@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:38:07AM -0600, Timur Tabi wrote:
> Greg KH wrote:
> 
> > No, you can use the /dev/serial/ links to determine exactly which is
> > which depending on the pci id, and other unique identifiers (serial
> > numbers, etc.)
> 
> I just booted a Linux kernel with the driver I just emailed you, and there's no
> /dev/serial/ directory.  The only directories under /dev/ are 'shm' and 'pts',
> both of which are empty.

Then plug in a serial port device and see what happens.  You didn't hook
everything up in your driver correctly it seems, do your devices show up
under /sys/class/tty?

> I'm also running a Fedora 13 x86 system, just to see if I need a full modern OS
> to see these files.  Again, there is no /dev/serial/, even though I have serial
> ports.

Dynamic ones like a usb to serial device?

> Also not that since I'm not registering the byte channels as serial devices, I
> wouldn't expect anything in /dev/serial/ to reference them.
> 
> What does my driver need to do in order for these /dev/xxxx/ entries to contain
> that information?

See the udev rules for details.

> > Is this somehow not public code?  What just changed in the past 15
> > minutes?
> 
> Sorry, when I said "not public", I didn't mean it in a legal sense.  Now that I
> think about it, I guess that doesn't make much sense.

Yes, it didn't :)
