Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1DLSof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:44:35 -0400
Received: from 8bytes.org ([88.198.83.132]:37501 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1DLSoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:44:34 -0400
Date: Tue, 12 Apr 2011 20:44:33 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110412184433.GF19819@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 10:15:11AM -0400, Alex Deucher wrote:
> On Tue, Apr 12, 2011 at 5:02 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > On Mon, Apr 11, 2011 at 05:40:11PM -0700, Linus Torvalds wrote:
> >> Let's hope the release cycle continues like this. I _like_ it when
> >> people really seem to follow the whole "big changes during the merge
> >> window" rules.
> >
> > Sorry for disturbing the silence, but radeon seems to have issues. I
> > tested -rc3 (and after that -rc1 which also has the issue) on my Laptop
> > and it just reboots after (or while?) GFX initialization. The last lines
> > of dmesg are:
> >
> >  Freeing unused kernel memory: 624k freed
> >  Write protecting the kernel read-only data: 8192k
> >  Freeing unused kernel memory: 1456k freed
> >  Freeing unused kernel memory: 16k freed
> >  udev: starting version 151
> >  udevd (62): /proc/62/oom_adj is deprecated, please use /proc/62/oom_score_adj instead.
> >  [drm] Initialized drm 1.1.0 20060810
> >  [drm] radeon defaulting to kernel modesetting.
> >  [drm] radeon kernel modesetting enabled.
> >  radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> >  [drm] initializing kernel modesetting (RS880 0x1002:0x9712).
> >  [drm] register mmio base: 0xD6400000
> >  [drm] register mmio size: 65536
> >  ATOM BIOS: HP_TAG
> >  radeon 0000:01:05.0: VRAM: 320M 0x00000000C0000000 - 0x00000000D3FFFFFF (320M used)
> >  radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
> >  [drm] Detected VRAM RAM=320M, BAR=256M
> >  [drm] RAM width 32bits DDR
> >  [TTM] Zone  kernel: Available graphics memory: 1896512 kiB.
> >  usb 7-2: new full speed USB device number 2 using ohci_hcd
> >  [TTM] Initializing pool allocator.
> >  [drm] radeon: 320M of VRAM memory ready
> >  [drm] radeon: 512M of GTT memory ready.
> >  [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> >  [drm] Driver supports precise vblank timestamp query.
> >  [drm] radeon: irq initialized.
> >  [drm] GART: num cpu pages 131072, num gpu pages 131072
> >  [drm] Loading RS780 Microcode
> >  radeon 0000:01:05.0: WB enabled
> >  [drm] ring test succeeded in 1 usecs
> >  [drm] radeon: ib pool ready.
> >
> > The card is a Radeon Mobility 4200:
> >
> > 01:05.0 VGA compatible controller: ATI Technologies Inc M880G [Mobility Radeon HD 4200]
> >        Subsystem: Hewlett-Packard Company Device 307e
> >        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> >        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >        Latency: 0, Cache Line Size: 64 bytes
> >        Interrupt: pin A routed to IRQ 18
> >        Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
> >        Region 1: I/O ports at 6000 [size=256]
> >        Region 2: Memory at d6400000 (32-bit, non-prefetchable) [size=64K]
> >        Region 5: Memory at d6300000 (32-bit, non-prefetchable) [size=1M]
> >        Capabilities: [50] Power Management version 3
> >                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> >                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> >        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
> >                Address: 0000000000000000  Data: 0000
> >        Kernel driver in use: radeon
> >        Kernel modules: radeon
> >
> > The problem does not happen with 2.6.38. I try to bisect this further down to a
> > commit. Alex, please let me know if you need any further information.
> 
> If you can bisect it, that would be great.  Thanks,

Bisecting actually gave a very weird result. It points to

	d2137d5af4259f50c19addb8246a186c9ffac325

which is a merge-commit in the x86 tree. Even more weird is that this
notebook is the only machine with these symptoms, all my other boxes are
fine.
During the bisect I tested commits from Yinghai which were good. It
seems like the problem appeared with the merge.

	Joerg

