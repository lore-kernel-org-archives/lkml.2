Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab0C2E0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 00:26:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62728 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab0C2E0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 00:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u3CJZU+Ko3nW2dwt1VQnWGGsxll8VcHTjEDe7CApAAvf/ZByb0fO1ONGRKiZhuD0LC
         nLuwPu9z0zS8iSfUHAi0XTgTVUVA3D/CHPNBOxYIjOL16iRPXzyrd2wYyDJXeWeerN83
         eJ4bNDc/94sguLggfXy7VC0d+UhnkpMU/nj/4=
MIME-Version: 1.0
In-Reply-To: <5bdc1c8b1003282044s23347905mfca7c41c37db6f18@mail.gmail.com>
References: <5bdc1c8b1003282044s23347905mfca7c41c37db6f18@mail.gmail.com>
Date: Mon, 29 Mar 2010 15:26:47 +1100
Message-ID: <d45a3acc1003282126uc8da45avaa641c0a2276c413@mail.gmail.com>
Subject: Re: 100%wa for long periods of time
From: andrew hendry <andrew.hendry@gmail.com>
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Do you know what is causing the wait?
Probably not the best way, but I have used something like the
following for a similar case before:
echo "1" > /proc/sys/vm/block_dump
... wait a short while ...
echo "0" > /proc/sys/vm/block_dump
Then have a look at dmesg | egrep "READ|WRITE|dirtied"

Andrew.

On Mon, Mar 29, 2010 at 2:44 PM, Mark Knecht <markknecht@gmail.com> wrote:
> Hi all,
>   Long time lurker. Seldom post here. I'm not a programmer.
>
>   OK, so I'm bring up new hardware - Intel i7 920, Intel DX58SO
> motherboard, 6GB Crucial triple channel DRAM. Using both the Gentoo
> install CD (2.6.32 based) as well as 2.6.33-gentoo after booting the
> install I am running into long periods of time - sometimes 30 seconds,
> sometimes lasting minutes, where the machine appears to hang or slow
> down very drastically. The only thing I've noticed so far is that
> there are 100% waiting periods showing up in top. No messages in dmesg
> or /var/log/messages. Just long periods where the the compiler acts
> like the system has really slowed down and sometimes appears almost
> completely dead.
>
>   When this clears up then the system screams along building
> software. When it happens is see things like the following where CPU's
> 1 & 5 sit at 100% waiting which lasted 2 or 3 minutes before clearing
> up. The CPU that goes to 100% does move around but it does seem to
> land on #5 more than others.
>
> keeper ~ # top
>
> top - 02:27:17 up 28 min,  2 users,  load average: 2.76, 1.95, 1.30
> Tasks: 125 total,   1 running, 124 sleeping,   0 stopped,   0 zombie
> Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu5  :  0.0%us,  0.3%sy,  0.0%ni,  0.0%id, 99.7%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu7  :  0.0%us,  0.3%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:   6107024k total,  1448676k used,  4658348k free,   187492k buffers
> Swap:  4200988k total,        0k used,  4200988k free,   915900k cached
>
>
> keeper ~ # lspci
> 00:00.0 Host bridge: Intel Corporation X58 I/O Hub to ESI Port (rev 13)
> 00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 1 (rev 13)
> 00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 3 (rev 13)
> 00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 7 (rev 13)
> 00:10.0 PIC: Intel Corporation 5520/5500/X58 Physical and Link Layer
> Registers Port 0 (rev 13)
> 00:10.1 PIC: Intel Corporation 5520/5500/X58 Routing and Protocol
> Layer Registers Port 0 (rev 13)
> 00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
> Registers (rev 13)
> 00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
> Pad Registers (rev 13)
> 00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
> and RAS Registers (rev 13)
> 00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 13)
> 00:19.0 Ethernet controller: Intel Corporation 82567LM-2 Gigabit
> Network Connection
> 00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #4
> 00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #5
> 00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #6
> 00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
> EHCI Controller #2
> 00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
> Audio Controller
> 00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 1
> 00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 2
> 00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 5
> 00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #1
> 00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #2
> 00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #3
> 00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
> EHCI Controller #1
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
> 00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
> 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
> AHCI Controller
> 00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
> 02:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce
> 9500 GT] (rev a1)
> 06:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II
> Controller (rev b2)
> 07:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
> IEEE-1394a-2000 Controller (PHY/Link)
> keeper ~ #
>
> keeper ~ # uname -a
> Linux keeper 2.6.33-gentoo #1 SMP PREEMPT Mon Mar 29 01:12:08 PDT 2010
> x86_64 Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
> keeper ~ #
>
> keeper ~ # lsmod
> Module                  Size  Used by
> ipv6                  207757  24
> usbhid                 21529  0
> snd_hda_codec_realtek   239530  1
> uhci_hcd               18047  0
> ehci_hcd               30854  0
> usbcore               115023  4 usbhid,uhci_hcd,ehci_hcd
> sg                     23029  0
> snd_hda_intel          17688  0
> snd_hda_codec          45755  2 snd_hda_codec_realtek,snd_hda_intel
> firewire_ohci          20022  0
> e1000e                111701  0
> snd_pcm                58104  2 snd_hda_intel,snd_hda_codec
> processor              23121  0
> rtc_cmos                7678  0
> snd_timer              15030  1 snd_pcm
> rtc_core               11093  1 rtc_cmos
> snd                    37476  5
> snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
> soundcore                800  1 snd
> snd_page_alloc          5809  2 snd_hda_intel,snd_pcm
> firewire_core          36109  1 firewire_ohci
> rtc_lib                 1617  1 rtc_core
> thermal                11650  0
> keeper ~ #
>
> Thanks,
> Mark
>
