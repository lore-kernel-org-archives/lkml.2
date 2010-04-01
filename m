Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0DATP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:15:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37511 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab0DATPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XLVYDpkqDcYIBV6Da5UJIUESJgz7UDKMBS0e8Bh+co4ewYwuX4RFyda/ODoFQ/qoOn
         iTfpsHdRjbP7klUfjISxiPW9+9yZuYU/h1H4CxKHHwCTkpMx9yNfH/MWw0fTA8FkoVcU
         vyUCdGdZetwFnQMWfuRJb+l4nFhdeb326pUvM=
MIME-Version: 1.0
In-Reply-To: <4BB44A96.60709@ladisch.de>
References: <64bb37e1003261025l14e2d82r64ba1e90d024bea6@mail.gmail.com>
	 <s5hfx3nm1lh.wl%tiwai@suse.de>
	 <64bb37e1003261059w3de67654m11ca17f1645f6c1@mail.gmail.com>
	 <s5hhbo26d68.wl%tiwai@suse.de>
	 <64bb37e1003261407y4d46c71cr3b39fc3058e0294a@mail.gmail.com>
	 <s5hd3yq6anu.wl%tiwai@suse.de>
	 <64bb37e1003270234p3c7a10e2kd066d4459a60bb51@mail.gmail.com>
	 <4BB44A96.60709@ladisch.de>
Date: Thu, 1 Apr 2010 21:15:53 +0200
Message-ID: <m2h64bb37e1004011215n763a5ae2i2929069a2127c593@mail.gmail.com>
Subject: Re: [alsa-devel] Regressions: MSI vs HDA-Intel
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 9:26 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Torsten Kaiser wrote:
>> So all the messages about the failing codec and MSI belong to
>> 0000:01:05.2, the HDMI output.
>
> MSI seems to be broken on all(?) Radeon IGPs; see
> <http://lkml.org/lkml/2010/3/30/290>.

If you refer to "PCI quirk: RS780/RS880: work around missing MSI
initialization", the system only has a RS690.
And as far as I know, MSI works for the graphics part:
~ # grep radeon /proc/interrupts
 25:          1        909   PCI-MSI-edge      radeon

(I'm only using fbcon, no Xserver running)

> Torsten, what is the output of "lspci -nn" on your first system?

00:00.0 Host bridge [0600]: ATI Technologies Inc RS690 Host Bridge [1002:7910]
00:01.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI
Bridge (Internal gfx) [1002:7912]
00:07.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI
Bridge (PCI Express Port 3) [1002:7917]
00:12.0 SATA controller [0106]: ATI Technologies Inc SB600 Non-Raid-5
SATA [1002:4380]
00:13.0 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI0)
[1002:4387]
00:13.1 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI1)
[1002:4388]
00:13.2 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI2)
[1002:4389]
00:13.3 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI3)
[1002:438a]
00:13.4 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI4)
[1002:438b]
00:13.5 USB Controller [0c03]: ATI Technologies Inc SB600 USB
Controller (EHCI) [1002:4386]
00:14.0 SMBus [0c05]: ATI Technologies Inc SBx00 SMBus Controller
[1002:4385] (rev 14)
00:14.1 IDE interface [0101]: ATI Technologies Inc SB600 IDE [1002:438c]
00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel
HDA) [1002:4383]
00:14.3 ISA bridge [0601]: ATI Technologies Inc SB600 PCI to LPC
Bridge [1002:438d]
00:14.4 PCI bridge [0604]: ATI Technologies Inc SBx00 PCI to PCI
Bridge [1002:4384]
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control [1022:1103]
01:05.0 VGA compatible controller [0300]: ATI Technologies Inc RS690
[Radeon X1200 Series] [1002:791e]
01:05.2 Audio device [0403]: ATI Technologies Inc Radeon X1200 Series
Audio Controller [1002:7919]
02:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev
01)
03:03.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL-8029(AS) [10ec:8029]
03:05.0 Ethernet controller [0200]: MYSON Technology Inc SURECOM
EP-320X-S 100/10M Ethernet PCI Adapter [1516:0803]
03:06.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. VT6306/7/8
[Fire II(M)] IEEE 1394 OHCI Controller [1106:3044] (rev c0)

But please note: The only problem is the 6 second delay during HDMI
audio initialization. And that was not fixed by
snd_hda_intel.enable_msi=0.
As I don't have any hardware to attach to the HDMI port, I probably
can't help you debugging this further then "the delay is gone".

Thanks, Torsten
