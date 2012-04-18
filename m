Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2DRCBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:01:41 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:46466 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752195Ab2DRCBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:01:39 -0400
Date: Tue, 17 Apr 2012 22:01:28 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Tom Bylander <bylander@cs.utsa.edu>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: Regression: black screen on VGA w/ nouveau in Linux 3.3
Message-ID: <20120418020128.GA3108@elliptictech.com>
References: <20120319143548.GA27172@elliptictech.com>
 <20120404012752.GA4227@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404012752.GA4227@elliptictech.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-03 21:27 -0400, Nick Bowler wrote:
> CCing Tom Bylander as he sent me a mail off-list saying he experiences
> a similar issue on an FX 5200.
> 
> Tom, maybe you'll have better luck bisecting this than I did?
> 
> On 2012-03-19 10:35 -0400, Nick Bowler wrote:
> > Just upgraded to Linux 3.3 on my desktop and noticed that the VGA output
> > on my card w/ nouveau is totally black (both at the console and in X).
> > Almost everything appears to work normally: DPMS works, modesetting
> > works, DDC works... all messages indicate that things are working --
> > just the image is completely black.
> 
> OK, so this is still reproducible on Linux 3.4-rc1+ (Linus' master).  I
> captured the dmesg output before (3.2.13, which is a working kernel),
> and after (3.3.1 and 3.4-rc1-00144-g01627d9 - both fail in an identical
> manner).  All three logs are attached in full (gzipped).

Ping?  I'm still seeing this on 3.4-rc3+.  Is there any other info that
I need to provide?

> One thing that immediately jumps out is the WARNING in the 3.4-rc1+ log
> that occurs early and did not appear in either of the other logs:
> 
> ------------[ cut here ]------------
> WARNING: at /home/nick/misc/linux-2.6/arch/x86/pci/i386.c:60
> pcibios_fwaddrmap_lookup+0x1d/0x3d()
> Hardware name: K8N-E-Deluxe
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 3.4.0-rc1-00144-g01627d9 #47
> Call Trace:
>  [<ffffffff81026baf>] warn_slowpath_common+0x80/0x98
>  [<ffffffff81026bdc>] warn_slowpath_null+0x15/0x17
>  [<ffffffff8129f79f>] pcibios_fwaddrmap_lookup+0x1d/0x3d
>  [<ffffffff81687306>] pcibios_allocate_resources+0xd4/0x217
>  [<ffffffff81688447>] ? pci_legacy_init+0x3e/0x3e
>  [<ffffffff81687460>] pcibios_resource_survey+0x17/0x2d
>  [<ffffffff81688dfd>] pcibios_init+0x28/0x3a
>  [<ffffffff8168848e>] pci_subsys_init+0x47/0x4d
>  [<ffffffff810002e2>] do_one_initcall+0x78/0x126
>  [<ffffffff81662bab>] kernel_init+0xe9/0x17a
>  [<ffffffff8166248a>] ? rdinit_setup+0x28/0x28
>  [<ffffffff8131ac44>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81662ac2>] ? start_kernel+0x321/0x321
>  [<ffffffff8131ac40>] ? gs_change+0xb/0xb
> ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> Other than that, I diffed the 3.2.13 log and 3.4-rc1+ log and grepped
> for nouveau-related differences.  I see no obvious errors, but I admit
> that I don't really know what to look for.
> 
> % diff -u nouveau-3.2.13.log nouveau-3.4-rc1+.log | grep -C3 '\[drm\]'
> 
> @@ -418,19 +429,21 @@
>  Real Time Clock Driver v1.12b
>  Linux agpgart interface v0.103
>  [drm] Initialized drm 1.1.0 20060810
> +VGA switcheroo: detected Optimus DSM method \ handle
>  ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 19
> -nouveau 0000:01:00.0: PCI INT A -> Link[LNKE] -> GSI 19 (level, low) -> IRQ 19
>  [drm] nouveau 0000:01:00.0: Detected an NV30 generation card (0x436200a1)
> -[drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
> +[drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
>  [drm] nouveau 0000:01:00.0: ... appears to be valid
> +[drm] nouveau 0000:01:00.0: Using VBIOS from PRAMIN
>  [drm] nouveau 0000:01:00.0: BMP BIOS found
>  [drm] nouveau 0000:01:00.0: BMP version 5.40
>  [drm] nouveau 0000:01:00.0: Bios version 04.36.20.21
> -[drm] nouveau 0000:01:00.0: Found Display Configuration Block version 2.2
> -[drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000300 00009c40
> -[drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02010310 00009c40
> -[drm] nouveau 0000:01:00.0: Raw DCB entry 2: 04000302 00000000
> -[drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02020321 00000303
> +[drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
> +[drm] nouveau 0000:01:00.0: DCB version 2.2
> +[drm] nouveau 0000:01:00.0: DCB outp 00: 01000300 00009c40
> +[drm] nouveau 0000:01:00.0: DCB outp 01: 02010310 00009c40
> +[drm] nouveau 0000:01:00.0: DCB outp 02: 04000302 00000000
> +[drm] nouveau 0000:01:00.0: DCB outp 03: 02020321 00000303
>  [drm] nouveau 0000:01:00.0: Loading NV17 power sequencing microcode
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xF01D
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xF4E1
> @@ -439,11 +452,10 @@
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xF8B3
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 5 at offset 0xF8D0
>  [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 6 at offset 0xF959
> -[drm] nouveau 0000:01:00.0: 0 available performance level(s)
> -[drm] nouveau 0000:01:00.0: c: core 425MHz memory 501MHz voltage 1350mV
> -[TTM] Zone  kernel: Available graphics memory: 512160 kiB.
> -[TTM] Initializing pool allocator.
> -[drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
> +[TTM] Zone  kernel: Available graphics memory: 512142 kiB
> +[TTM] Initializing pool allocator
> +[TTM] Initializing DMA pool allocator
> +[drm] nouveau 0000:01:00.0: Detected 256MiB VRAM (DDR1)
>  agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
>  agpgart: swapper tried to set rate=x12. Setting to AGP3 x8 mode.
>  agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
> @@ -452,11 +464,14 @@
>  [drm] nouveau 0000:01:00.0: Saving VGA fonts
>  [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>  [drm] No driver support for vblank timestamp query.
> +[drm] nouveau 0000:01:00.0: 0 available performance level(s)
> +[drm] nouveau 0000:01:00.0: c: core 425MHz memory 501MHz voltage 1350mV
> +[drm] nouveau 0000:01:00.0: 0xE51A: Parsing digital output script table
>  [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 0)
>  [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 1)
>  [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on tmds encoder (output 2)
>  [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on TV encoder (output 3)
> -[drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x49000, bo ffff88003da11400
> +[drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x49000, bo ffff88003e314c00
>  fbcon: nouveaufb (fb0) is primary device
>  [drm] nouveau 0000:01:00.0: 0xE51A: Parsing digital output script table
>  [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on tmds encoder (output 2)
> @@ -466,12 +481,11 @@
>  Console: switching to colour frame buffer device 160x64
>  fb0: nouveaufb frame buffer device
>  drm: registered panic notifier
> -[drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
> +[drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0 on minor 0
>  brd: module loaded
>  sata_nv 0000:00:0a.0: version 3.5
>  ACPI: PCI Interrupt Link [LTID] BIOS reported IRQ 0, using IRQ 22
> --
> +NFS: Registering the id_resolver key type
>  it87: Found IT8712F chip at 0xd00, revision 7
>  it87: VID is disabled (pins used for GPIO)
>  [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 1)
> 
> > The VGA is one of two outputs in use: the other (DVI) output works
> > normally.  The card also has an unused TV-out port, FWIW.
> >
> > The card is an NV36 generation (Geforce FX5700 AGP).  This is a
> > regression from Linux 3.2 -- unfortunately, bisection has proved
> > extremely difficult because the intermediate kernels git is asking me
> > to test panic immediately on boot (and compiling Linux takes a fairly
> > long time on this box too).  The failed attempt went like this:
> >
> >   git bisect start 'drivers/gpu'
> >   # bad: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
> >   git bisect bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7
> >   # good: [805a6af8dba5dfdd35ec35dc52ec0122400b2610] Linux 3.2
> >   git bisect good 805a6af8dba5dfdd35ec35dc52ec0122400b2610
> >   # skip: [5d56fe5fd794a98c4f446f8665fd06b82e93ff64] Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next
> >   git bisect skip 5d56fe5fd794a98c4f446f8665fd06b82e93ff64
> >   # good: [dffc9ceb55695f121adc57dd1fde7304c3afe81e] gma500: kill virtual mapping support
> >   git bisect good dffc9ceb55695f121adc57dd1fde7304c3afe81e
> >   # skip: [5c2a5ce689c99037771a6c110374461781a6f042] drm: add missing exports for i810 driver.
> >   git bisect skip 5c2a5ce689c99037771a6c110374461781a6f042
> >   # skip: [44517c44496062180a6376cc704b33129441ce60] drm/radeon/kms: Add an MSI quirk for Dell RS690
> >   git bisect skip 44517c44496062180a6376cc704b33129441ce60
> >
> >   (I stopped at this point)
> >
> > I'm running the latest git xf86-video-nouveau, but since the issue
> > occurs at the console it's probably not too important...

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

