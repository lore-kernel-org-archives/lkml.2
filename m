Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0DZUeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:34:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41660 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753145Ab0DZUef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:34:35 -0400
Date: Mon, 26 Apr 2010 16:34:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Invalid opcode on resume from STR on Asus P4P800-VM
In-Reply-To: <201004262155.06949.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.1004261631320.1764-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010, Ondrej Zary wrote:

> On Monday 26 April 2010 21:17:27 Alan Stern wrote:
> > On Mon, 26 Apr 2010, Ondrej Zary wrote:
> > > Hello,
> > > I'm trying to debug oops on resume from suspend-to-RAM on Asus P4P800-VM
> > > mainboard. It crashes with invalid opcode (see below). The kernel is
> > > 2.6.32-trunk from Debian but the same problem is present with vanilla
> > > kernels - both newer and older (but screen remains blank most of the
> > > time, only keyboard LEDs blink indicating an oops).
> > >
> > > What can cause this problem?
> > >
> > >      8.000339  invalid opcode: 0000 [#1] SMP
> > >      8.003529  last sysfs file: /sys/power/state
> > >      8.004265  Modules linked in: sco bridge stp bnep l2cacp crc16
> > > bluetooth rfkill loop i2c_i801 snd_intel8x0 snd_ac97_codec shpchp
> > > ac97_bus parport_pc parport
> > > rng_core pci_hotplug snd_pcsp snd_pcm snd_timer snd soundcore psmouse
> > > snd_page_alloc serio_raw evdev processor ext3 jbd mbcache ide_gd_mod
> > > ata_generic libata scsi_mod
> > > ide_pci_generic i915 drm_kms_helper uhci_hcd drm i2c_algo_bit piix
> > > i2c_core ehci_hcd intel_agp e100 video ide_core mii floppy agpgart output
> > > usbcore nls_base button
> > > thermal fan thermal_sys [last unloaded: scsi_wait_scan]
> > > [  148.004265]
> > > [  148.004265] Pid: 0, comm: swapper Not tainted (2.6.32-trunk-686 #1) To
> > > Be Filled By O.E.M. [  148.004265] EIP: 0060:[<c1008ff3>] EFLAGS:
> > > 00010086 CPU: 0
> > > [  148.004265] EIP is at mwait_idle+0x4e/0x6c
> >
> > I had exactly the same problem (on an HP computer with an Intel
> > chipset).  As far as anyone could figure out, it is caused by a bug in
> > the BIOS.  It's not entirely clear that this is the complete answer,
> > but nothing else turned up.  See
> >
> > 	http://bugzilla.kernel.org/show_bug.cgi?id=15385
> >
> > for the complete record.  The best solution I could find was to boot
> > with "idle=halt" on the command line.  You might check to see if any
> > BIOS updates are available.
> 
> Thanks, it does not crash with "idle=halt" or "idle=poll". According to this:
> http://siyobik.info/index.php?module=x86&id=215
> the MWAIT instruction can be enabled/disabled in IA32_MISC_ENABLES MSR. Kernel 
> probably should enable it at boot and also on resume.
> Here's some more info:
> http://software.intel.com/en-us/forums/showthread.php?t=63654

That could be the answer.  Clearly this should be handled by the 
arch-specific boot/setup code.  I don't know enough about it, but other 
people do.

Alan Stern

