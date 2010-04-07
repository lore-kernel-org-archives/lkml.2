Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0DGENk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 00:13:40 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:39187 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0DGENe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 00:13:34 -0400
Date: Tue, 6 Apr 2010 21:13:33 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset
	failed (0xffffffff)
Message-ID: <20100407041333.GF29192@hexapodia.org>
References: <20100406225425.GA8292@hexapodia.org> <1270612783.8518.15.camel@dc7800.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270612783.8518.15.camel@dc7800.home>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 09:59:43PM -0600, Bjorn Helgaas wrote:
> > I suspect it's due to:
> > 
> > [    3.094038] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
> > [    3.103001] pci 0000:00:1f.2: can't reserve [mem 0xff970000-0xff9707ff]
> 
> Thanks a lot for reporting this!
> 
> No need to bisect it.  I'm pretty sure 2.6.34-rc1 will boot fine if you
> use "pci=use_crs" (obviously that's only a temporary workaround until we
> fix the real problem).

pci=nocrs worked on 2.6.34-rc3-00299-g0fdf867.  I won't be back in front
of the machine to try use_crs until Thursday.

> put AHCI device, so we moved the AHCI device.  Unfortunately, we put it
> at [mem 0x000a0000-0x000a07ff], which wasn't a very good choice because
> that's probably already used by a VGA device.

The machine has one VGA controller exposed currently; there may be
another integrated Intel video controller on the motherboard and
disabled by the BIOS.

01:00.0 VGA compatible controller: nVidia Corporation Quadro NVS 290 (rev a1) (prog-if 00 [VGA controller])
        Subsystem: nVidia Corporation Device 0492
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
        I/O ports at dc80 [size=128]
        Expansion ROM at fde00000 [disabled] [size=128K]
        Capabilities: <access denied>
        Kernel driver in use: nouveau

(this is from the pci=nocrs boot.)

> If you happen to have Windows on this box, I'd love to know whether *it*
> moves the AHCI device, too, or whether Windows interprets the BIOS
> information differently than we do.  If you have Windows and can collect
> screenshots of the Device Manager resources for the PCI bus and the AHCI
> controller, that would be a good start.

The machine only has Linux installed, but I may have access to another
T3400 that can dual-boot.  Any preference for XP versus Win7?

> Would you mind trying the patch below and the patch and kernel args
> here:
>   https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5
> 
> This will (1) reserve the VGA area, so we should put the AHCI device
> elsewhere, and (2) collect a few more details about exactly what the
> BIOS is reporting.

I'll try that on Thursday.

-andy
