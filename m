Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1ANALY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:11:24 -0500
Received: from mail.vyatta.com ([76.74.103.46]:51369 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1ANALS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:11:18 -0500
Date: Thu, 13 Jan 2011 16:11:15 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Pekka Enberg <penberg@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block driver updates for 2.6.38
Message-ID: <20110113161115.1d564448@nehalam>
In-Reply-To: <AANLkTikdULkbB83Us_zXivv8Y5FGdHrixUXRiitacaSh@mail.gmail.com>
References: <4D2F03F2.4000707@fusionio.com>
	<AANLkTi=t9FQaUhnXCk51bjZO82F8OGDDd9H5HyMPRPQd@mail.gmail.com>
	<4D2F51B5.6060105@fusionio.com>
	<AANLkTi=PDEyJNN3aKhHWzCKrTfzib-VCdvgD7auoWuzD@mail.gmail.com>
	<20110113141957.1eaf4940@nehalam>
	<AANLkTikdULkbB83Us_zXivv8Y5FGdHrixUXRiitacaSh@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011 16:02:12 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 13, 2011 at 2:19 PM, Stephen Hemminger
> <shemminger@vyatta.com> wrote:
> >
> > It looks my floppy format problem wasn't my patch but the HPET-MSI
> > problem. https://patchwork.kernel.org/patch/69588/
> >
> > Why hasn't that been fixed in mainline kernel?
> 
> Because the proper fix was _supposed_ to be the one that disabled MSI
> for just the affected AMD boards. See
> 
>   commit 73472a46b5b28116b145fb5fc05242c1aa8e1461
>   Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
>   Date:   Thu Jan 21 11:09:52 2010 -0800
> 
>     x86: Disable HPET MSI on ATI SB700/SB800
> 
>     HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
>     side-effects on floppy DMA. Do not use HPET MSI on such platforms.
> 
>     Original problem report from Mark Hounschell
>     http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01118.html
> 
>     [ This patch needs to go to stable as well. But, there are some
>       conflicts that prevents the patch from going as is. I can
>       rebase/resubmit to stable once the patch goes upstream.
>       hpa: still Cc:'ing stable@ as an FYI. ]
> 
>     Tested-by: Mark Hounschell <markh@compro.net>
>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>     Cc: <stable@kernel.org>
>     LKML-Reference: <20100121190952.GA32523@linux-os.sc.intel.com>
>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> 
> and if you have the same problem (MSI + floppy doesn't work), can you
> give more information about your system?
> 
> In particular, is it an AMD southbridge that we don't have listed?
> Right now we only trigger it for machines that match this:
> 
>   PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS
> 
> (which is PCI device 1002:4385) and it may be that we have incomplete coverage.
> 
> And so few people use floppies (and expect them to work), that we
> probably have very bad test coverage too.

It appears to be a different problem (not HPET MSI). Not sure what
is causing it, but even 2.6.35 can't format a floppy without error.


00:00.0 Host bridge: Intel Corporation 5520/5500/X58 I/O Hub to ESI Port (rev 12)
00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 12)
00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 3 (rev 12)
00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 7 (rev 12)
00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management Registers (rev 12)
00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers (rev 12)
00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers (rev 12)
00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 12)
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 1
00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 3
00:1c.3 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 4
00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 5
00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 6
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2
01:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
01:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
02:00.0 VGA compatible controller: ATI Technologies Inc RV535 [Radeon X1650 Series] (rev 9e)
02:00.1 Display controller: ATI Technologies Inc RV535 [Radeon X1650 Series] (rev 9e)
03:00.0 PCI bridge: Integrated Device Technology, Inc. PES12N3A PCI Express Switch (rev 0e)
04:02.0 PCI bridge: Integrated Device Technology, Inc. PES12N3A PCI Express Switch (rev 0e)
04:04.0 PCI bridge: Integrated Device Technology, Inc. PES12N3A PCI Express Switch (rev 0e)
05:00.0 Ethernet controller: Intel Corporation 82575GB Gigabit Network Connection (rev 02)
05:00.1 Ethernet controller: Intel Corporation 82575GB Gigabit Network Connection (rev 02)
06:00.0 Ethernet controller: Intel Corporation 82575GB Gigabit Network Connection (rev 02)
06:00.1 Ethernet controller: Intel Corporation 82575GB Gigabit Network Connection (rev 02)
07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)
08:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II Controller (rev b2)
09:00.0 RAID bus controller: Marvell Technology Group Ltd. 88SE6440 SAS/SATA PCIe controller (rev 02)
0a:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)


-- 
