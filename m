Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab0FOOxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:53:46 -0400
Received: from dtp.xs4all.nl ([80.101.171.8]:50859 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757762Ab0FOOxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:53:44 -0400
Date: Tue, 15 Jun 2010 16:53:42 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan <alan@clueserver.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Question on siig sata 3 controller
Message-ID: <20100615145342.GC26989@bitwizard.nl>
References: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2> <4C10A81F.50801@garzik.org> <54318.10.6.6.23.1276222123.squirrel@10.6.6.2> <20100615065714.GA9034@bitwizard.nl> <20100615110748.4303a106@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615110748.4303a106@lxorguk.ukuu.org.uk>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 11:07:48AM +0100, Alan Cox wrote:
> > A reboot brings the disks back to life. So in theory, Linux should be
> > able to restore life into these drives by doing the right magic with
> > the hardware bits... 
 
> We don't have power control of the drives. If the firmware crashes
> or a drive flakes out due to power problems or something similar
> occurs its game over until you hit the switch.

The thing is, the power didn't cycle. I just typed "reboot" from a
remote location. (Yes, in most cases leading up to yesterday's/this
morning's event I thought I had to powercycle to bring them back, but
I tried "just the reboot" this morning and it worked!)

The controller has TWO drives connected. BOTH drives became
inaccessible at exactly the same point in time. This has happened
before, with BOTH drives disappearing at the same moment.

The RAID superblocks on BOTH drives had info like: 
      RAID disk 1/8, raid is up 8/8
say for disk numbers 1,2. 

All six other drives had
      RAID disk 4/8, raid is broken 6/8
say, for disk numbers 0, 3,4,5,6,7

Next time this happens, I'll try removing and reinserting all the sata
modules (the machine is a file-server. It's NFS-root so it doesn't
depend on the storage modules for it's root fs.... :-) )

sata_nv                20758  0 
ahci                   36037  6 

Is one of these modules the driver for this controller? I think it's
AHCI: lshw says it uses ports cc00 ... and a bunch of others, and
those ports are claimed by ahci according to /proc/ioports. Ah! I need
better eyes. lshw already mentions that it's ahci...

> > ata5: hard resetting link
> > ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 370)
> 
> We tried the biggest hammer we had

Not big enough! De BIOS manages a bigger one!

	Roger.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
