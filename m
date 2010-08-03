Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0HCRqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:46:33 -0400
Received: from phil.doycomm.com ([66.219.128.249]:45529 "EHLO phil.doycomm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab0HCRqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:46:32 -0400
Subject: Re: Linux 2.6.35
From: Donald Parsons <dparsons@brightdsl.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Harald Hoyer <harald.hoyer@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100803094031.2fb8e538.rdunlap@xenotime.net>
References: <1280716262.5125.42.camel@falcon.homelinux.org>
	 <201008012138.39036.bjorn.helgaas@hp.com>
	 <1280722876.5125.83.camel@falcon.homelinux.org>
	 <AANLkTimK8sv5aWfcv_BAmipgVnukR5NJsZQOXYbb2LAH@mail.gmail.com>
	 <1280802701.5836.10.camel@falcon.homelinux.org>
	 <20100802214249.b0fee617.rdunlap@xenotime.net>
	 <1280852810.5209.40.camel@falcon.homelinux.org>
	 <20100803094031.2fb8e538.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 13:45:45 -0400
Message-ID: <1280857545.5209.61.camel@falcon.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 09:40 -0700, Randy Dunlap wrote:
> On Tue, 03 Aug 2010 12:26:50 -0400 Donald Parsons wrote:
> 
> > Resending to all...
> > On Mon, 2010-08-02 at 21:42 -0700, Randy Dunlap wrote:
> > > On Mon, 02 Aug 2010 22:31:41 -0400 Donald Parsons wrote:
> > > 
> > > > On Mon, 2010-08-02 at 18:08 +0200, Harald Hoyer wrote: 
> > > > > On Mon, Aug 2, 2010 at 6:21 AM, Donald Parsons <dparsons@brightdsl.net> wrote:
> > > > > > On Sun, 2010-08-01 at 21:38 -0600, Bjorn Helgaas wrote:
> > > > > >> On Sunday, August 01, 2010 08:31:02 pm Donald Parsons wrote:
> > > > > >> > 2.6.35 still fails to boot for me, as first reported here:
> > > > > >> >  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html
> > > > > >> >
> > > > > >> > I've manually bisected it down to around May 20 between
> > > > > >> >   2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
> > > > > >> > Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.
> > > > > >> >
> > > > > >> > Unfortunately first time I tried was with 2.6.35-rc6 and
> > > > > >> > it failed to boot.
> > > > > >> >
> > > > > >> > Failure when switching from initramfs to real /root?
> > > > > >> > Removing kernel "quiet" param appears to show several
> > > > > >> > lines listing:
> > > > > >> >
> > > > > >> >   usb drives/hubs? followed by
> > > > > >> >   dracut switching root (when booting works)
> > > > > >> >               or
> > > > > >> >   usb drives/hubs? followed by
> > > > > >> >         (missing dracut... line)
> > > > > >> >   No root device found
> > > > > >> >   Boot has failed, sleeping forever.   (when it does not boot)
> > > > > >> >
> > > > > >> > Grub, typical entry:
> > > > > >> > title Fedora (2.6.35)
> > > > > >> >     root (hd0,0)
> > > > > >> >     kernel /vmlinuz-2.6.35 ro
> > > > > >> > root=UUID=686dc496-8814-4c36-8fb7-5ded2916e825 rhgb
> > > > > >> > SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
> > > > > >> > rdblacklist=nouveau init=/sbin/bootchartd
> > > > > >> >     initrd /initramfs-2.6.35.img
> > > > > >> >
> > > > > >> >
> > > > > >> > My boot failure seems to be different than other two reported
> > > > > >> > in the thread "2.6.35-rc6-git6: Reported regressions from 2.6.34"
> > > > > >> > under Bug #16173 and #16228
> > > > > >>
> > > > > >> Will it boot with the "pci=nocrs" option?  If so, please open a
> > > > > >
> > > > > > No, I tried this on a few attempts when I saw it mentioned under
> > > > > > bug #16228.  But it had no effect/benefit.  Sorry, I should have
> > > > > > mentioned this.
> > > > > >
> > > > > >> report at https://bugzilla.kernel.org, mark it a regression, assign
> > > > > >> it to me, and attach the complete dmesg log.  And please respond to
> > > > > >> this thread with a pointer to the bugzilla.
> > > > > >>
> > > > > >> Otherwise, a complete console log should have a clue.  The best
> > > > > >> thing would be a log from a serial console or netconsole, with
> > > > > >> "ignore_loglevel".
> > > > > >
> > > > > > Maybe I will try netconsole tomorrow.  But is Ethernet up when
> > > > > > this boot failure happens?  I think not, since initramfs should
> > > > > > not need networking.
> > > > > >
> > > > > > Should I try building sata driver into kernel?  Oh, I am using
> > > > > > ext3, and fdisk -l shows:
> > > > > 
> > > > > # dracut --add-drivers "sata" ....
> > > > > 
> > > > > or edit /etc/dracut.conf:
> > > > > 
> > > > > add_drivers+=" sata "
> > > > 
> > > > But the kernel used to boot with same identical modules before
> > > > but not after 2.6.34-git4.
> > > >  --------
> > > > 
> > > > Using your suggestion as to where the problem lies, I investigated
> > > > more deeply and found:
> > > > 
> > > > I've now got 2.6.35-rc6-git3 to boot (and almost certainly 2.6.35 final)
> > > > 
> > > > Make oldconfig broke at the transition where boot began failed, ie,
> > > > between 2.6.34-git4 and 2.6.34-git5.   Even though modules are the
> > > > same, boot fails.  If I use gconfig and set CONFIG_SATA_AHCI=y
> > > > instead of CONFIG_SATA_AHCI=m it works, except cannot select =y
> > > > unless CONFIG_ATA changed from m to y.
> > > > 
> > > > So at some point in past, make oldconfig had apparently changed
> > > > CONFIG_SATA_AHCI from y to m and system still booted.  But between
> > > > 2.6.34-git4 and 2.6.34-git5 the ability to boot was lost.
> > > > 
> > > > So make oldconfig is not 100% trustworthy in this case.  I do not
> > > > know if this is a problem that should be fixed.  Ask if you want
> > > > any .config diffs.
> > > > 
> > > > I am going to reboot with 2.6.35 to make sure it boots. Yes!
> > > > 
> > > > I consider this boot problem solved unless someone wants to
> > > > improve "make oldconfig" behavior.
> > > 
> > > It would be good to be able to explain what you are seeing & describing,
> > > so yes, if you can send a .config file that exhibits the problem, I'd
> > > love to look at it.
> > > 
> > > thanks,
> > > ---
> > > ~Randy
> > 
> > 
> > Okay, here is the diff between 2.6.34-git4 and 2.6.34-git5
> > It should be equivalent to make silentoldconfig as I made no
> > changes, just enter to accept defaults.  The git4 boots and
> > git5 does not boot.     (Both based off 2.6.34.1.config)
> 
> Yes, I had just generated this same diff.
> The only config change that could remotely make a difference is:
> > +# CONFIG_SATA_AHCI_PLATFORM is not set
> 
> and I don't see how it could matter.
> 
> > (and attached config-2.6.34-git4.gz, because .config was too
> >  big for mail list last time.)
> 
> Last time being recently?  lkml accepts email sizes (with attachments)
> up to 300 KB, IIRC.

Maybe http://lkml.indiana.edu/hypermail/linux/kernel/1008.0/index.html
throws out large email but the actual lkml does not?  I did not see
it show up; here is header of email that had large (56.48K) .config:

From: 	Donald Parsons
To: 	Randy Dunlap
Cc: 	linux-kernel <linux-kernel@vger.k.o>, Linus Torvalds
Subject: Re: Linux 2.6.35
Date: 	08/01/2010 11:41:31 PM  (this is EDT)
Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 


> > --- config-2.6.34-git4  2010-08-01 19:52:48.000000000 -0400
> > +++ config-2.6.34-git5  2010-08-01 18:10:14.000000000 -0400
> > @@ -1,7 +1,7 @@
> >  #
> >  # Automatically generated make config: don't edit
...deleted most lines...
> > -#
> >  # CONFIG_STAGING is not set
> >  CONFIG_X86_PLATFORM_DEVICES=y
> >  # CONFIG_ACER_WMI is not set
> > 
> > -------------------------------------------
> > 
> > Can possibly duplicate problem if you have a 
> > sata based PC from last few years.
> > 
> > Set  CONFIG_ATA=m
> 
> That's already =m in this config file.
> 
> > and this becomes CONFIG_SATA_AHCI=m  (cannot select=y)
> 
> That's as expected.  CONFIG_ATA value controls CONFIG_SATA_AHCI
> possible values.
> 
> > 
> > Then 2.6.34.[01] (probably 2 also) will boot.
> > Make silentoldconfig with this .config and see
> > that 2.6.35 will not boot.
> 
> So with CONFIG_ATA=m and CONFIG_SATA_AHCI=m, does 2.6.34-git4 boot
> but 2.6.34-git5 fails to boot?

Yes, that is exactly correct.

Don





