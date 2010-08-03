Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0HCQ2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:28:43 -0400
Received: from phil.doycomm.com ([66.219.128.249]:43498 "EHLO phil.doycomm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab0HCQ2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:28:41 -0400
Subject: Re: Linux 2.6.35
From: Donald Parsons <dparsons@brightdsl.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Harald Hoyer <harald.hoyer@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100802214249.b0fee617.rdunlap@xenotime.net>
References: <1280716262.5125.42.camel@falcon.homelinux.org>
	 <201008012138.39036.bjorn.helgaas@hp.com>
	 <1280722876.5125.83.camel@falcon.homelinux.org>
	 <AANLkTimK8sv5aWfcv_BAmipgVnukR5NJsZQOXYbb2LAH@mail.gmail.com>
	 <1280802701.5836.10.camel@falcon.homelinux.org>
	 <20100802214249.b0fee617.rdunlap@xenotime.net>
Content-Type: multipart/mixed; boundary="=-uLDd/EeO7Z0q8HwLsX+K"
Date: Tue, 03 Aug 2010 12:26:50 -0400
Message-ID: <1280852810.5209.40.camel@falcon.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uLDd/EeO7Z0q8HwLsX+K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Resending to all...
On Mon, 2010-08-02 at 21:42 -0700, Randy Dunlap wrote:
> On Mon, 02 Aug 2010 22:31:41 -0400 Donald Parsons wrote:
> 
> > On Mon, 2010-08-02 at 18:08 +0200, Harald Hoyer wrote: 
> > > On Mon, Aug 2, 2010 at 6:21 AM, Donald Parsons <dparsons@brightdsl.net> wrote:
> > > > On Sun, 2010-08-01 at 21:38 -0600, Bjorn Helgaas wrote:
> > > >> On Sunday, August 01, 2010 08:31:02 pm Donald Parsons wrote:
> > > >> > 2.6.35 still fails to boot for me, as first reported here:
> > > >> >  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html
> > > >> >
> > > >> > I've manually bisected it down to around May 20 between
> > > >> >   2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
> > > >> > Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.
> > > >> >
> > > >> > Unfortunately first time I tried was with 2.6.35-rc6 and
> > > >> > it failed to boot.
> > > >> >
> > > >> > Failure when switching from initramfs to real /root?
> > > >> > Removing kernel "quiet" param appears to show several
> > > >> > lines listing:
> > > >> >
> > > >> >   usb drives/hubs? followed by
> > > >> >   dracut switching root (when booting works)
> > > >> >               or
> > > >> >   usb drives/hubs? followed by
> > > >> >         (missing dracut... line)
> > > >> >   No root device found
> > > >> >   Boot has failed, sleeping forever.   (when it does not boot)
> > > >> >
> > > >> > Grub, typical entry:
> > > >> > title Fedora (2.6.35)
> > > >> >     root (hd0,0)
> > > >> >     kernel /vmlinuz-2.6.35 ro
> > > >> > root=UUID=686dc496-8814-4c36-8fb7-5ded2916e825 rhgb
> > > >> > SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
> > > >> > rdblacklist=nouveau init=/sbin/bootchartd
> > > >> >     initrd /initramfs-2.6.35.img
> > > >> >
> > > >> >
> > > >> > My boot failure seems to be different than other two reported
> > > >> > in the thread "2.6.35-rc6-git6: Reported regressions from 2.6.34"
> > > >> > under Bug #16173 and #16228
> > > >>
> > > >> Will it boot with the "pci=nocrs" option?  If so, please open a
> > > >
> > > > No, I tried this on a few attempts when I saw it mentioned under
> > > > bug #16228.  But it had no effect/benefit.  Sorry, I should have
> > > > mentioned this.
> > > >
> > > >> report at https://bugzilla.kernel.org, mark it a regression, assign
> > > >> it to me, and attach the complete dmesg log.  And please respond to
> > > >> this thread with a pointer to the bugzilla.
> > > >>
> > > >> Otherwise, a complete console log should have a clue.  The best
> > > >> thing would be a log from a serial console or netconsole, with
> > > >> "ignore_loglevel".
> > > >
> > > > Maybe I will try netconsole tomorrow.  But is Ethernet up when
> > > > this boot failure happens?  I think not, since initramfs should
> > > > not need networking.
> > > >
> > > > Should I try building sata driver into kernel?  Oh, I am using
> > > > ext3, and fdisk -l shows:
> > > 
> > > # dracut --add-drivers "sata" ....
> > > 
> > > or edit /etc/dracut.conf:
> > > 
> > > add_drivers+=" sata "
> > 
> > But the kernel used to boot with same identical modules before
> > but not after 2.6.34-git4.
> >  --------
> > 
> > Using your suggestion as to where the problem lies, I investigated
> > more deeply and found:
> > 
> > I've now got 2.6.35-rc6-git3 to boot (and almost certainly 2.6.35 final)
> > 
> > Make oldconfig broke at the transition where boot began failed, ie,
> > between 2.6.34-git4 and 2.6.34-git5.   Even though modules are the
> > same, boot fails.  If I use gconfig and set CONFIG_SATA_AHCI=y
> > instead of CONFIG_SATA_AHCI=m it works, except cannot select =y
> > unless CONFIG_ATA changed from m to y.
> > 
> > So at some point in past, make oldconfig had apparently changed
> > CONFIG_SATA_AHCI from y to m and system still booted.  But between
> > 2.6.34-git4 and 2.6.34-git5 the ability to boot was lost.
> > 
> > So make oldconfig is not 100% trustworthy in this case.  I do not
> > know if this is a problem that should be fixed.  Ask if you want
> > any .config diffs.
> > 
> > I am going to reboot with 2.6.35 to make sure it boots. Yes!
> > 
> > I consider this boot problem solved unless someone wants to
> > improve "make oldconfig" behavior.
> 
> It would be good to be able to explain what you are seeing & describing,
> so yes, if you can send a .config file that exhibits the problem, I'd
> love to look at it.
> 
> thanks,
> ---
> ~Randy


Okay, here is the diff between 2.6.34-git4 and 2.6.34-git5
It should be equivalent to make silentoldconfig as I made no
changes, just enter to accept defaults.  The git4 boots and
git5 does not boot.     (Both based off 2.6.34.1.config)

(and attached config-2.6.34-git4.gz, because .config was too
 big for mail list last time.)

--- config-2.6.34-git4  2010-08-01 19:52:48.000000000 -0400
+++ config-2.6.34-git5  2010-08-01 18:10:14.000000000 -0400
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.34-git4
-# Sun Aug  1 19:52:48 2010
+# Linux kernel version: 2.6.34-git5
+# Sun Aug  1 18:10:14 2010
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -544,7 +544,7 @@
 CONFIG_YENTA_TOSHIBA=y
 CONFIG_PD6729=m
 CONFIG_I82092=m
-CONFIG_PCCARD_NONSTATIC=m
+CONFIG_PCCARD_NONSTATIC=y
 CONFIG_HOTPLUG_PCI=y
 CONFIG_HOTPLUG_PCI_FAKE=m
 CONFIG_HOTPLUG_PCI_ACPI=m
@@ -1474,7 +1474,9 @@
 CONFIG_ATA_ACPI=y
 CONFIG_SATA_PMP=y
 CONFIG_SATA_AHCI=m
+# CONFIG_SATA_AHCI_PLATFORM is not set
 CONFIG_SATA_SIL24=m
+CONFIG_SATA_INIC162X=m
 CONFIG_ATA_SFF=y
 CONFIG_SATA_SVW=m
 CONFIG_ATA_PIIX=m
@@ -1489,7 +1491,6 @@
 CONFIG_SATA_ULI=m
 CONFIG_SATA_VIA=m
 CONFIG_SATA_VITESSE=m
-CONFIG_SATA_INIC162X=m
 CONFIG_PATA_ACPI=m
 CONFIG_PATA_ALI=m
 CONFIG_PATA_AMD=m
@@ -1882,6 +1883,7 @@
 CONFIG_KEYBOARD_ATKBD=y
 # CONFIG_QT2160 is not set
 # CONFIG_KEYBOARD_LKKBD is not set
+# CONFIG_KEYBOARD_TCA6416 is not set
 # CONFIG_KEYBOARD_LM8323 is not set
 # CONFIG_KEYBOARD_MAX7359 is not set
 # CONFIG_KEYBOARD_NEWTON is not set
@@ -1944,6 +1946,7 @@
 # CONFIG_TOUCHSCREEN_AD7879_I2C is not set
 # CONFIG_TOUCHSCREEN_AD7879 is not set
 # CONFIG_TOUCHSCREEN_DYNAPRO is not set
+# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
 # CONFIG_TOUCHSCREEN_EETI is not set
 CONFIG_TOUCHSCREEN_FUJITSU=m
 CONFIG_TOUCHSCREEN_GUNZE=m
@@ -1977,6 +1980,7 @@
 # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
 # CONFIG_TOUCHSCREEN_TSC2007 is not set
 CONFIG_INPUT_MISC=y
+# CONFIG_INPUT_AD714X is not set
 CONFIG_INPUT_PCSPKR=m
 CONFIG_INPUT_APANEL=m
 CONFIG_INPUT_ATLAS_BTNS=m
@@ -1988,6 +1992,7 @@
 # CONFIG_INPUT_CM109 is not set
 CONFIG_INPUT_UINPUT=m
 # CONFIG_INPUT_WINBOND_CIR is not set
+# CONFIG_INPUT_PCF8574 is not set
 
 #
 # Hardware I/O ports
@@ -2377,7 +2382,6 @@
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
 # CONFIG_MFD_WM8400 is not set
-# CONFIG_MFD_WM8994 is not set
 # CONFIG_MFD_PCF50633 is not set
 # CONFIG_LPC_SCH is not set
 # CONFIG_REGULATOR is not set
@@ -2398,6 +2402,13 @@
 #
 CONFIG_IR_CORE=m
 CONFIG_VIDEO_IR=m
+CONFIG_RC_MAP=m
+CONFIG_IR_NEC_DECODER=m
+CONFIG_IR_RC5_DECODER=m
+CONFIG_IR_RC6_DECODER=m
+CONFIG_IR_JVC_DECODER=m
+CONFIG_IR_SONY_DECODER=m
+# CONFIG_IR_IMON is not set
 # CONFIG_MEDIA_ATTACH is not set
 CONFIG_MEDIA_TUNER=m
 # CONFIG_MEDIA_TUNER_CUSTOMISE is not set
@@ -2416,8 +2427,8 @@
 # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
 CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
 CONFIG_VIDEO_IR_I2C=m
-# CONFIG_VIDEO_VIVI is not set
 # CONFIG_VIDEO_BT848 is not set
+# CONFIG_VIDEO_W9966 is not set
 # CONFIG_VIDEO_SAA5246A is not set
 # CONFIG_VIDEO_SAA5249 is not set
 # CONFIG_VIDEO_ZORAN is not set
@@ -2477,10 +2488,10 @@
 # CONFIG_USB_ET61X251 is not set
 # CONFIG_USB_SN9C102 is not set
 # CONFIG_USB_ZC0301 is not set
-CONFIG_USB_PWC_INPUT_EVDEV=y
 # CONFIG_USB_ZR364XX is not set
 # CONFIG_USB_STKWEBCAM is not set
 # CONFIG_USB_S2255 is not set
+# CONFIG_V4L_MEM2MEM_DRIVERS is not set
 CONFIG_RADIO_ADAPTERS=y
 # CONFIG_RADIO_GEMTEK_PCI is not set
 # CONFIG_RADIO_MAXIRADIO is not set
@@ -2695,6 +2706,7 @@
 CONFIG_SND_ALS300=m
 CONFIG_SND_ALS4000=m
 CONFIG_SND_ALI5451=m
+# CONFIG_SND_ASIHPI is not set
 CONFIG_SND_ATIIXP=m
 CONFIG_SND_ATIIXP_MODEM=m
 CONFIG_SND_AU8810=m
@@ -2734,6 +2746,7 @@
 CONFIG_SND_ENS1371=m
 CONFIG_SND_ES1938=m
 CONFIG_SND_ES1968=m
+# CONFIG_SND_ES1968_INPUT is not set
 CONFIG_SND_FM801=m
 # CONFIG_SND_FM801_TEA575X_BOOL is not set
 CONFIG_SND_HDA_INTEL=m
@@ -2769,6 +2782,7 @@
 CONFIG_SND_KORG1212=m
 # CONFIG_SND_LX6464ES is not set
 CONFIG_SND_MAESTRO3=m
+# CONFIG_SND_MAESTRO3_INPUT is not set
 CONFIG_SND_MIXART=m
 CONFIG_SND_NM256=m
 CONFIG_SND_PCXHR=m
@@ -3148,10 +3162,6 @@
 # CONFIG_UIO_SERCOS3 is not set
 # CONFIG_UIO_PCI_GENERIC is not set
 # CONFIG_UIO_NETX is not set
-
-#
-# TI VLYNQ
-#
 # CONFIG_STAGING is not set
 CONFIG_X86_PLATFORM_DEVICES=y
 # CONFIG_ACER_WMI is not set

-------------------------------------------

Can possibly duplicate problem if you have a 
sata based PC from last few years.

Set  CONFIG_ATA=m
and this becomes CONFIG_SATA_AHCI=m  (cannot select=y)

Then 2.6.34.[01] (probably 2 also) will boot.
Make silentoldconfig with this .config and see
that 2.6.35 will not boot.

Thanks,
Don



--=-uLDd/EeO7Z0q8HwLsX+K
Content-Type: application/x-gzip; name="config-2.6.34-git4.gz"
Content-Disposition: attachment; filename="config-2.6.34-git4.gz"
Content-Transfer-Encoding: base64

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


--=-uLDd/EeO7Z0q8HwLsX+K--

