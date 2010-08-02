Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0HBNra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:47:30 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:13594 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0HBNr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:47:29 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Donald Parsons <dparsons@brightdsl.net>
Subject: Re: Linux 2.6.35
Date: Mon, 2 Aug 2010 07:48:09 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <1280716262.5125.42.camel@falcon.homelinux.org> <201008012138.39036.bjorn.helgaas@hp.com> <1280722876.5125.83.camel@falcon.homelinux.org>
In-Reply-To: <1280722876.5125.83.camel@falcon.homelinux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008020748.09968.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 01, 2010 10:21:16 pm Donald Parsons wrote:
> On Sun, 2010-08-01 at 21:38 -0600, Bjorn Helgaas wrote:
> > On Sunday, August 01, 2010 08:31:02 pm Donald Parsons wrote:
> > > 2.6.35 still fails to boot for me, as first reported here:
> > >  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html
> > > 
> > > I've manually bisected it down to around May 20 between
> > >   2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
> > > Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.
> > > 
> > > Unfortunately first time I tried was with 2.6.35-rc6 and
> > > it failed to boot.
> > > 
> > > Failure when switching from initramfs to real /root?
> > > Removing kernel "quiet" param appears to show several
> > > lines listing:
> > > 
> > >   usb drives/hubs? followed by
> > >   dracut switching root (when booting works)
> > >               or
> > >   usb drives/hubs? followed by
> > >         (missing dracut... line)
> > >   No root device found
> > >   Boot has failed, sleeping forever.   (when it does not boot)
> > > 
> > > Grub, typical entry:
> > > title Fedora (2.6.35)
> > > 	root (hd0,0)
> > > 	kernel /vmlinuz-2.6.35 ro
> > > root=UUID=686dc496-8814-4c36-8fb7-5ded2916e825 rhgb
> > > SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
> > > rdblacklist=nouveau init=/sbin/bootchartd
> > > 	initrd /initramfs-2.6.35.img
> > > 
> > > 
> > > My boot failure seems to be different than other two reported
> > > in the thread "2.6.35-rc6-git6: Reported regressions from 2.6.34"
> > > under Bug #16173 and #16228
> > 
> > Will it boot with the "pci=nocrs" option?  If so, please open a
> 
> No, I tried this on a few attempts when I saw it mentioned under
> bug #16228.  But it had no effect/benefit.  Sorry, I should have
> mentioned this.
> 
> > report at https://bugzilla.kernel.org, mark it a regression, assign
> > it to me, and attach the complete dmesg log.  And please respond to
> > this thread with a pointer to the bugzilla.
> > 
> > Otherwise, a complete console log should have a clue.  The best
> > thing would be a log from a serial console or netconsole, with
> > "ignore_loglevel".
> 
> Maybe I will try netconsole tomorrow.  But is Ethernet up when
> this boot failure happens?  I think not, since initramfs should
> not need networking.

Netconsole has special kernel support that doesn't require the normal
networking stack to be configured, so it works quite early.  You
would want to build your networking driver into the kernel for the
most benefit.

If that doesn't work, you could try capturing the log on VGA with a
digital camera or video camera, possibly with "boot_delay=" to
slow things down.

> Should I try building sata driver into kernel?

I doubt that will make a difference.  It seems like the problem
is that we don't find your root filesystem, probably because there's
something wrong with the HBA leading to that device.  For example,
maybe the PCI core mistakenly moved or disabled the adapter, or
there's some problem with its interrupt.

Bjorn
