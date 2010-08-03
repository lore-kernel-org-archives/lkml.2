Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab0HCQko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:40:44 -0400
Received: from xenotime.net ([72.52.115.56]:48341 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756696Ab0HCQkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:40:43 -0400
Date: Tue, 3 Aug 2010 09:40:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Donald Parsons <dparsons@brightdsl.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Harald Hoyer <harald.hoyer@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.35
Message-Id: <20100803094031.2fb8e538.rdunlap@xenotime.net>
In-Reply-To: <1280852810.5209.40.camel@falcon.homelinux.org>
References: <1280716262.5125.42.camel@falcon.homelinux.org>
	<201008012138.39036.bjorn.helgaas@hp.com>
	<1280722876.5125.83.camel@falcon.homelinux.org>
	<AANLkTimK8sv5aWfcv_BAmipgVnukR5NJsZQOXYbb2LAH@mail.gmail.com>
	<1280802701.5836.10.camel@falcon.homelinux.org>
	<20100802214249.b0fee617.rdunlap@xenotime.net>
	<1280852810.5209.40.camel@falcon.homelinux.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 12:26:50 -0400 Donald Parsons wrote:

> Resending to all...
> On Mon, 2010-08-02 at 21:42 -0700, Randy Dunlap wrote:
> > On Mon, 02 Aug 2010 22:31:41 -0400 Donald Parsons wrote:
> > 
> > > On Mon, 2010-08-02 at 18:08 +0200, Harald Hoyer wrote: 
> > > > On Mon, Aug 2, 2010 at 6:21 AM, Donald Parsons <dparsons@brightdsl.net> wrote:
> > > > > On Sun, 2010-08-01 at 21:38 -0600, Bjorn Helgaas wrote:
> > > > >> On Sunday, August 01, 2010 08:31:02 pm Donald Parsons wrote:
> > > > >> > 2.6.35 still fails to boot for me, as first reported here:
> > > > >> >  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html
> > > > >> >
> > > > >> > I've manually bisected it down to around May 20 between
> > > > >> >   2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
> > > > >> > Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.
> > > > >> >
> > > > >> > Unfortunately first time I tried was with 2.6.35-rc6 and
> > > > >> > it failed to boot.
> > > > >> >
> > > > >> > Failure when switching from initramfs to real /root?
> > > > >> > Removing kernel "quiet" param appears to show several
> > > > >> > lines listing:
> > > > >> >
> > > > >> >   usb drives/hubs? followed by
> > > > >> >   dracut switching root (when booting works)
> > > > >> >               or
> > > > >> >   usb drives/hubs? followed by
> > > > >> >         (missing dracut... line)
> > > > >> >   No root device found
> > > > >> >   Boot has failed, sleeping forever.   (when it does not boot)
> > > > >> >
> > > > >> > Grub, typical entry:
> > > > >> > title Fedora (2.6.35)
> > > > >> >     root (hd0,0)
> > > > >> >     kernel /vmlinuz-2.6.35 ro
> > > > >> > root=UUID=686dc496-8814-4c36-8fb7-5ded2916e825 rhgb
> > > > >> > SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
> > > > >> > rdblacklist=nouveau init=/sbin/bootchartd
> > > > >> >     initrd /initramfs-2.6.35.img
> > > > >> >
> > > > >> >
> > > > >> > My boot failure seems to be different than other two reported
> > > > >> > in the thread "2.6.35-rc6-git6: Reported regressions from 2.6.34"
> > > > >> > under Bug #16173 and #16228
> > > > >>
> > > > >> Will it boot with the "pci=nocrs" option?  If so, please open a
> > > > >
> > > > > No, I tried this on a few attempts when I saw it mentioned under
> > > > > bug #16228.  But it had no effect/benefit.  Sorry, I should have
> > > > > mentioned this.
> > > > >
> > > > >> report at https://bugzilla.kernel.org, mark it a regression, assign
> > > > >> it to me, and attach the complete dmesg log.  And please respond to
> > > > >> this thread with a pointer to the bugzilla.
> > > > >>
> > > > >> Otherwise, a complete console log should have a clue.  The best
> > > > >> thing would be a log from a serial console or netconsole, with
> > > > >> "ignore_loglevel".
> > > > >
> > > > > Maybe I will try netconsole tomorrow.  But is Ethernet up when
> > > > > this boot failure happens?  I think not, since initramfs should
> > > > > not need networking.
> > > > >
> > > > > Should I try building sata driver into kernel?  Oh, I am using
> > > > > ext3, and fdisk -l shows:
> > > > 
> > > > # dracut --add-drivers "sata" ....
> > > > 
> > > > or edit /etc/dracut.conf:
> > > > 
> > > > add_drivers+=" sata "
> > > 
> > > But the kernel used to boot with same identical modules before
> > > but not after 2.6.34-git4.
> > >  --------
> > > 
> > > Using your suggestion as to where the problem lies, I investigated
> > > more deeply and found:
> > > 
> > > I've now got 2.6.35-rc6-git3 to boot (and almost certainly 2.6.35 final)
> > > 
> > > Make oldconfig broke at the transition where boot began failed, ie,
> > > between 2.6.34-git4 and 2.6.34-git5.   Even though modules are the
> > > same, boot fails.  If I use gconfig and set CONFIG_SATA_AHCI=y
> > > instead of CONFIG_SATA_AHCI=m it works, except cannot select =y
> > > unless CONFIG_ATA changed from m to y.
> > > 
> > > So at some point in past, make oldconfig had apparently changed
> > > CONFIG_SATA_AHCI from y to m and system still booted.  But between
> > > 2.6.34-git4 and 2.6.34-git5 the ability to boot was lost.
> > > 
> > > So make oldconfig is not 100% trustworthy in this case.  I do not
> > > know if this is a problem that should be fixed.  Ask if you want
> > > any .config diffs.
> > > 
> > > I am going to reboot with 2.6.35 to make sure it boots. Yes!
> > > 
> > > I consider this boot problem solved unless someone wants to
> > > improve "make oldconfig" behavior.
> > 
> > It would be good to be able to explain what you are seeing & describing,
> > so yes, if you can send a .config file that exhibits the problem, I'd
> > love to look at it.
> > 
> > thanks,
> > ---
> > ~Randy
> 
> 
> Okay, here is the diff between 2.6.34-git4 and 2.6.34-git5
> It should be equivalent to make silentoldconfig as I made no
> changes, just enter to accept defaults.  The git4 boots and
> git5 does not boot.     (Both based off 2.6.34.1.config)

Yes, I had just generated this same diff.
The only config change that could remotely make a difference is:
> +# CONFIG_SATA_AHCI_PLATFORM is not set

and I don't see how it could matter.

> (and attached config-2.6.34-git4.gz, because .config was too
>  big for mail list last time.)

Last time being recently?  lkml accepts email sizes (with attachments)
up to 300 KB, IIRC.


> --- config-2.6.34-git4  2010-08-01 19:52:48.000000000 -0400
> +++ config-2.6.34-git5  2010-08-01 18:10:14.000000000 -0400
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
> -# Linux kernel version: 2.6.34-git4
> -# Sun Aug  1 19:52:48 2010
> +# Linux kernel version: 2.6.34-git5
> +# Sun Aug  1 18:10:14 2010
>  #
>  CONFIG_64BIT=y
>  # CONFIG_X86_32 is not set
> @@ -544,7 +544,7 @@
>  CONFIG_YENTA_TOSHIBA=y
>  CONFIG_PD6729=m
>  CONFIG_I82092=m
> -CONFIG_PCCARD_NONSTATIC=m
> +CONFIG_PCCARD_NONSTATIC=y
>  CONFIG_HOTPLUG_PCI=y
>  CONFIG_HOTPLUG_PCI_FAKE=m
>  CONFIG_HOTPLUG_PCI_ACPI=m
> @@ -1474,7 +1474,9 @@
>  CONFIG_ATA_ACPI=y
>  CONFIG_SATA_PMP=y
>  CONFIG_SATA_AHCI=m
> +# CONFIG_SATA_AHCI_PLATFORM is not set
>  CONFIG_SATA_SIL24=m
> +CONFIG_SATA_INIC162X=m
>  CONFIG_ATA_SFF=y
>  CONFIG_SATA_SVW=m
>  CONFIG_ATA_PIIX=m
> @@ -1489,7 +1491,6 @@
>  CONFIG_SATA_ULI=m
>  CONFIG_SATA_VIA=m
>  CONFIG_SATA_VITESSE=m
> -CONFIG_SATA_INIC162X=m
>  CONFIG_PATA_ACPI=m
>  CONFIG_PATA_ALI=m
>  CONFIG_PATA_AMD=m
> @@ -1882,6 +1883,7 @@
>  CONFIG_KEYBOARD_ATKBD=y
>  # CONFIG_QT2160 is not set
>  # CONFIG_KEYBOARD_LKKBD is not set
> +# CONFIG_KEYBOARD_TCA6416 is not set
>  # CONFIG_KEYBOARD_LM8323 is not set
>  # CONFIG_KEYBOARD_MAX7359 is not set
>  # CONFIG_KEYBOARD_NEWTON is not set
> @@ -1944,6 +1946,7 @@
>  # CONFIG_TOUCHSCREEN_AD7879_I2C is not set
>  # CONFIG_TOUCHSCREEN_AD7879 is not set
>  # CONFIG_TOUCHSCREEN_DYNAPRO is not set
> +# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
>  # CONFIG_TOUCHSCREEN_EETI is not set
>  CONFIG_TOUCHSCREEN_FUJITSU=m
>  CONFIG_TOUCHSCREEN_GUNZE=m
> @@ -1977,6 +1980,7 @@
>  # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
>  # CONFIG_TOUCHSCREEN_TSC2007 is not set
>  CONFIG_INPUT_MISC=y
> +# CONFIG_INPUT_AD714X is not set
>  CONFIG_INPUT_PCSPKR=m
>  CONFIG_INPUT_APANEL=m
>  CONFIG_INPUT_ATLAS_BTNS=m
> @@ -1988,6 +1992,7 @@
>  # CONFIG_INPUT_CM109 is not set
>  CONFIG_INPUT_UINPUT=m
>  # CONFIG_INPUT_WINBOND_CIR is not set
> +# CONFIG_INPUT_PCF8574 is not set
>  
>  #
>  # Hardware I/O ports
> @@ -2377,7 +2382,6 @@
>  # CONFIG_HTC_PASIC3 is not set
>  # CONFIG_MFD_TMIO is not set
>  # CONFIG_MFD_WM8400 is not set
> -# CONFIG_MFD_WM8994 is not set
>  # CONFIG_MFD_PCF50633 is not set
>  # CONFIG_LPC_SCH is not set
>  # CONFIG_REGULATOR is not set
> @@ -2398,6 +2402,13 @@
>  #
>  CONFIG_IR_CORE=m
>  CONFIG_VIDEO_IR=m
> +CONFIG_RC_MAP=m
> +CONFIG_IR_NEC_DECODER=m
> +CONFIG_IR_RC5_DECODER=m
> +CONFIG_IR_RC6_DECODER=m
> +CONFIG_IR_JVC_DECODER=m
> +CONFIG_IR_SONY_DECODER=m
> +# CONFIG_IR_IMON is not set
>  # CONFIG_MEDIA_ATTACH is not set
>  CONFIG_MEDIA_TUNER=m
>  # CONFIG_MEDIA_TUNER_CUSTOMISE is not set
> @@ -2416,8 +2427,8 @@
>  # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
>  CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
>  CONFIG_VIDEO_IR_I2C=m
> -# CONFIG_VIDEO_VIVI is not set
>  # CONFIG_VIDEO_BT848 is not set
> +# CONFIG_VIDEO_W9966 is not set
>  # CONFIG_VIDEO_SAA5246A is not set
>  # CONFIG_VIDEO_SAA5249 is not set
>  # CONFIG_VIDEO_ZORAN is not set
> @@ -2477,10 +2488,10 @@
>  # CONFIG_USB_ET61X251 is not set
>  # CONFIG_USB_SN9C102 is not set
>  # CONFIG_USB_ZC0301 is not set
> -CONFIG_USB_PWC_INPUT_EVDEV=y
>  # CONFIG_USB_ZR364XX is not set
>  # CONFIG_USB_STKWEBCAM is not set
>  # CONFIG_USB_S2255 is not set
> +# CONFIG_V4L_MEM2MEM_DRIVERS is not set
>  CONFIG_RADIO_ADAPTERS=y
>  # CONFIG_RADIO_GEMTEK_PCI is not set
>  # CONFIG_RADIO_MAXIRADIO is not set
> @@ -2695,6 +2706,7 @@
>  CONFIG_SND_ALS300=m
>  CONFIG_SND_ALS4000=m
>  CONFIG_SND_ALI5451=m
> +# CONFIG_SND_ASIHPI is not set
>  CONFIG_SND_ATIIXP=m
>  CONFIG_SND_ATIIXP_MODEM=m
>  CONFIG_SND_AU8810=m
> @@ -2734,6 +2746,7 @@
>  CONFIG_SND_ENS1371=m
>  CONFIG_SND_ES1938=m
>  CONFIG_SND_ES1968=m
> +# CONFIG_SND_ES1968_INPUT is not set
>  CONFIG_SND_FM801=m
>  # CONFIG_SND_FM801_TEA575X_BOOL is not set
>  CONFIG_SND_HDA_INTEL=m
> @@ -2769,6 +2782,7 @@
>  CONFIG_SND_KORG1212=m
>  # CONFIG_SND_LX6464ES is not set
>  CONFIG_SND_MAESTRO3=m
> +# CONFIG_SND_MAESTRO3_INPUT is not set
>  CONFIG_SND_MIXART=m
>  CONFIG_SND_NM256=m
>  CONFIG_SND_PCXHR=m
> @@ -3148,10 +3162,6 @@
>  # CONFIG_UIO_SERCOS3 is not set
>  # CONFIG_UIO_PCI_GENERIC is not set
>  # CONFIG_UIO_NETX is not set
> -
> -#
> -# TI VLYNQ
> -#
>  # CONFIG_STAGING is not set
>  CONFIG_X86_PLATFORM_DEVICES=y
>  # CONFIG_ACER_WMI is not set
> 
> -------------------------------------------
> 
> Can possibly duplicate problem if you have a 
> sata based PC from last few years.
> 
> Set  CONFIG_ATA=m

That's already =m in this config file.

> and this becomes CONFIG_SATA_AHCI=m  (cannot select=y)

That's as expected.  CONFIG_ATA value controls CONFIG_SATA_AHCI
possible values.

> 
> Then 2.6.34.[01] (probably 2 also) will boot.
> Make silentoldconfig with this .config and see
> that 2.6.35 will not boot.

So with CONFIG_ATA=m and CONFIG_SATA_AHCI=m, does 2.6.34-git4 boot
but 2.6.34-git5 fails to boot?


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
