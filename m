Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0HCOta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:49:30 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:1748 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab0HCOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:49:28 -0400
Date: Tue, 3 Aug 2010 11:48:10 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Kailang Yang <kailang@realtek.com>, Daniel T Chen <crimsun@ubuntu.com>,
        alsa-devel@alsa-project.org
Subject: Re: Regression 2.6.35: Intel N10/ICH 7 Family HDA (Realtek ALC662
 rev1) beep broken
Message-ID: <20100803144810.GD3508@llucax.com.ar>
References: <20100803040054.GX3508@llucax.com.ar>
 <s5h39uw6ymf.wl%tiwai@suse.de>
 <20100803134409.GA3508@llucax.com.ar>
 <s5hhbjblscn.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhbjblscn.wl%tiwai@suse.de>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai, el  3 de agosto a las 15:48 me escribiste:
> At Tue, 3 Aug 2010 10:44:09 -0300,
> Leandro Lucarella wrote:
> > 
> > > Please give alsa-info.sh output.
> > 
> > I didn't know where to find the script,
> 
> It's listed in Documentation/sound/alsa/HD-Audio.txt :)

Woops!

> > Google gave me this:
> > http://git.alsa-project.org/?p=alsa-driver.git;a=blob_plain;f=utils/alsa-info.sh
> > So this is what I've use. I've shared the results at:
> > http://www.alsa-project.org/db/?f=6a051da2475c7246f40c493a310fecb0a1a289f5
> > 
> > > > I've tried to naively (I'm not a kernel hacker, so I was just guessing) add a
> > > > new entry with the quirks beep_white_list by copying the entry for ASUS like
> > > > this:
> > > > 
> > > > diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> > > > index 596ea2f..ca3ed12 100644
> > > > --- a/sound/pci/hda/patch_realtek.c
> > > > +++ b/sound/pci/hda/patch_realtek.c
> > > > @@ -5183,6 +5183,7 @@ static void fillup_priv_adc_nids(struct hda_codec *codec, hda_nid_t *nid
> > > >  
> > > >  static struct snd_pci_quirk beep_white_list[] = {
> > > >         SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
> > > > +       SND_PCI_QUIRK(0x8086, 0xd613, "INTEL", 1),
> > > >         {}
> > > >  };
> > > >  
> > > > But it didn't work either.
> > > 
> > > Hm, this should work.  At least, you should have beep mixer & co with
> > > this.
> > 
> > Well, my bad, I booted the wrong kernel when trying the patch. The patch
> > works correctly, so I'll be very glad if it hits Linus kernel soon :)
> > 
> > I could send you the patch but I don't know exactly what to put in the
> > commit message. The problem is the same as the one with the ASUS P5-V?
> 
> I can add such a trivial patch manually, of course.  But I'd need
> to know which machine you have (vendor/model name, etc).

Is a desktop box.
CPU Intel(R) Core(TM)2 Quad CPU    Q8400  @ 2.66GHz
Motherboard Intel Corporation DG41RQ

Let me know if you need any other information.


Thank you.

Here is the output of lshw:

# lshw -short
H/W path               Device       Class       Description
===========================================================
                                    system      Desktop Computer
/0                                  bus         DG41RQ
/0/0                                memory      64KiB BIOS
/0/4                                processor   Intel(R) Core(TM)2 Quad CPU    Q8400  @ 2.66GHz
/0/4/5                              memory      32KiB L1 cache
/0/4/6                              memory      2MiB L2 cache
/0/2a                               memory      2GiB System Memory
/0/2a/0                             memory      DIMM Synchronous [empty]
/0/2a/1                             memory      2GiB DIMM DDR2 Synchronous 800 MHz (1.2 ns)
/0/100                              bridge      4 Series Chipset DRAM Controller
/0/100/1                            bridge      4 Series Chipset PCI Express Root Port
/0/100/2                            display     4 Series Chipset Integrated Graphics Controller
/0/100/1b                           multimedia  N10/ICH 7 Family High Definition Audio Controller
/0/100/1c                           bridge      N10/ICH 7 Family PCI Express Port 1
/0/100/1c.1                         bridge      N10/ICH 7 Family PCI Express Port 2
/0/100/1c.1/0          eth0         network     RTL8111/8168B PCI Express Gigabit Ethernet controller
/0/100/1d                           bus         N10/ICH 7 Family USB UHCI Controller #1
/0/100/1d.1                         bus         N10/ICH 7 Family USB UHCI Controller #2
/0/100/1d.2                         bus         N10/ICH 7 Family USB UHCI Controller #3
/0/100/1d.3                         bus         N10/ICH 7 Family USB UHCI Controller #4
/0/100/1d.7                         bus         N10/ICH 7 Family USB2 EHCI Controller
/0/100/1e                           bridge      82801 PCI Bridge
/0/100/1e/0                         multimedia  Bt848 Video Capture
/0/100/1f                           bridge      82801GB/GR (ICH7 Family) LPC Interface Bridge
/0/100/1f.1            scsi0        storage     82801G (ICH7 Family) IDE Controller
/0/100/1f.1/0.0.0      /dev/cdrom1  disk        DVDRW SOHW-832S
/0/100/1f.1/0.0.0/0    /dev/cdrom1  disk        
/0/100/1f.1/0.1.0      /dev/sda     disk        160GB WDC WD1600JB-00G
/0/100/1f.1/0.1.0/1    /dev/sda1    volume      54MiB EXT3 volume
/0/100/1f.1/0.1.0/2    /dev/sda2    volume      74GiB Linux filesystem partition
/0/100/1f.1/0.1.0/3    /dev/sda3    volume      74GiB Linux filesystem partition
/0/100/1f.2            scsi2        storage     N10/ICH7 Family SATA IDE Controller
/0/100/1f.2/0.0.0      /dev/sdb     disk        640GB WDC WD6400AAKS-6
/0/100/1f.2/0.0.0/1    /dev/sdb1    volume      258MiB EXT3 volume
/0/100/1f.2/0.0.0/2    /dev/sdb2    volume      595GiB Extended partition
/0/100/1f.2/0.0.0/2/5  /dev/sdb5    volume      73GiB Linux filesystem partition
/0/100/1f.2/0.0.0/2/6  /dev/sdb6    volume      73GiB Linux filesystem partition
/0/100/1f.2/0.0.0/2/7  /dev/sdb7    volume      73GiB Linux filesystem partition
/0/100/1f.2/0.0.0/2/8  /dev/sdb8    volume      73GiB Linux filesystem partition
/0/100/1f.2/0.0.0/2/9  /dev/sdb9    volume      73GiB Linux filesystem partition
/0/100/1f.2/0.0.0/2/a  /dev/sdb10   volume      73GiB Linux filesystem partition
/0/100/1f.2/0.0.0/2/b  /dev/sdb11   volume      73GiB Linux filesystem partition
/0/100/1f.2/0.0.0/2/c  /dev/sdb12   volume      77GiB Linux filesystem partition
/0/100/1f.3                         bus         N10/ICH 7 Family SMBus Controller


-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
Can you stand up?
I do believe it's working, good.
That'll keep you going through the show
Come on it's time to go.
