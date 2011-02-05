Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1BEOS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:18:57 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:19627
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab1BEOS4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:18:56 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Feb 2011 09:18:56 EST
X-SpamScore: -43
X-BigFish: VPS-43(zzbb2cK936eK146fK1102K542N1432N98dN14ffO4015L9371P3d32m12b6izz1202hzzz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Updates to devicetree/arm branch
Date: Sat, 5 Feb 2011 07:03:44 -0700
In-Reply-To: <AANLkTikOe21SPAtUY+5KhgpCFaK8g3mRS1GkG4uaDXL=@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Updates to devicetree/arm branch
Thread-Index: AcvDZjsX8HvQ+nanSrOBKHIUdr/3TwB1rEFA
References: <AANLkTikOe21SPAtUY+5KhgpCFaK8g3mRS1GkG4uaDXL=@mail.gmail.com>
From: John Linn <John.Linn@xilinx.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
CC: <nicolas.pitre@linaro.org>, <linux-kernel@vger.kernel.org>,
        <buytenh@wantstofly.org>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>,
        John Bonesio <bones@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
X-OriginalArrivalTime: 05 Feb 2011 14:03:46.0016 (UTC) FILETIME=[811EFE00:01CBC53D]
X-RCIS-Action: ALLOW
Message-ID: <fe42a8b2-2161-4216-84f2-b31f756bffdc@VA3EHSMHS029.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> Sent: Wednesday, February 02, 2011 10:50 PM
> To: devicetree-discuss
> Cc: nicolas.pitre@linaro.org; linux-kernel@vger.kernel.org; buytenh@wantstofly.org; Olof Johansson;
> linux-arm-kernel@lists.infradead.org; John Bonesio; Jeremy Kerr; Rob Herring; John Linn; Thomas
> Abraham
> Subject: Updates to devicetree/arm branch
> 
> Hi all,
> 
> I've just push a few more commits out to devicetree/arm which picks up
> the removal of early machine_type lookup, picks up Rob's
> atags-anywhere patch (an earlier version, not the one rebased on
> Russell's p2v branch; I'll update to Rob's latest in the 2.6.39
> timeframe), and fixes the dtb corruption issue that I ran into (Thanks
> to John Bonesio for the debug help).  I was trying to use
> memblock_alloc() for early memory allocation when I should have been
> using alloc_bootmem_align().  Oops.
> 
> Anyway, it seems to be working well for me, but it needs more testing.
> Give it a try if you're interested.  The tree details are below:
> 
> John, hopefully this will solve all the dtb base address issues you
> were having.  You *should* be able to locate the dtb anywhere in ram
> now, except in a region used by the kernel and it cannot be based at
> physical address 0.

I pulled your new tree into mine and retested.  I retested with a dtb at 0x1000, 
0x400000, 0x1000000, and 0x8000000 successfully.  No issues booting with 
the device tree.

I think this patch set would help us transition to device tree easily.

Thanks,
John

> 
> I'll leave it out there for a day or two and clean some stuff up
> before posting the rebased series for a 3rd round of review.
> 
> Cheers,
> g.
> 
> The following changes since commit ebf53826e105f488f4f628703a108e98940d1dc5:
> 
>   Linux 2.6.38-rc3 (2011-02-01 13:05:49 +1000)
> 
> are available in the git repository at:
>   git://git.secretlab.ca/git/linux-2.6.git devicetree/arm
> 
> Grant Likely (14):
>       arm/dt: Make __vet_atags also accept a dtb image
>       arm/dt: allow bootmem reservation for device tree blob and initrd
>       arm/dt: consolidate atags setup into setup_machine_atags
>       arm/dt: probe for platforms via the device tree
>       arm/dt: Basic versatile devicetree support
>       arm/tegra: Fix tegra irq_data conversion
>       arm/dt: Basic tegra devicetree support
>       arm/dt: Fixup bugs in device tree __vet_atags changes
>       Merge v2.6.38-rc1 into devicetree/arm
>       Merge v2.6.38-rc2 into devicetree/arm
>       dt/arm: Save dtb in allocated buffer instead of reserved region
>       Merge commit 'v2.6.38-rc3' into devicetree/arm
>       arm/dt: Fixed memory allocation and missing of_fdt.h header
>       Revert "dt/arm: Save dtb in allocated buffer instead of reserved region"
> 
> Jeremy Kerr (1):
>       arm/dt: Allow CONFIG_OF on ARM
> 
> Rob Herring (1):
>       ARM/dt: map ATAGs when not in first 1MB of RAM
> 
> Russell King (1):
>       arm: Defer lookup of machine_type and vet of atags to setup.c
> 
>  arch/arm/Kconfig                       |    7 ++
>  arch/arm/include/asm/mach/arch.h       |    2 +
>  arch/arm/include/asm/prom.h            |   34 +++++++++
>  arch/arm/include/asm/setup.h           |    4 +
>  arch/arm/kernel/Makefile               |    1 +
>  arch/arm/kernel/devtree.c              |  107 +++++++++++++++++++++++++++++
>  arch/arm/kernel/head-common.S          |  114 +++++--------------------------
>  arch/arm/kernel/head-nommu.S           |    3 -
>  arch/arm/kernel/head.S                 |   36 +++++++---
>  arch/arm/kernel/setup.c                |  117 ++++++++++++++++++++++----------
>  arch/arm/mach-tegra/board-harmony.c    |    6 ++
>  arch/arm/mach-versatile/versatile_ab.c |    6 ++
>  arch/arm/mach-versatile/versatile_pb.c |    6 ++
>  arch/arm/mm/init.c                     |   22 ++++++
>  14 files changed, 318 insertions(+), 147 deletions(-)
>  create mode 100644 arch/arm/include/asm/prom.h
>  create mode 100644 arch/arm/kernel/devtree.c
> 
> 
> On Tue, Feb 1, 2011 at 11:21 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > [restored cc: list]
> >
> > On Tue, Feb 01, 2011 at 08:11:15AM -0700, John Linn wrote:
> >> OK, I see your changes don't really help the problem with device
> >> trees up higher.
> >>
> >> The problem is that in setup_machine_fdt the kernel can't get to the
> >> memory where the device tree is located if it's up higher.
> >
> > No, there is another patch to solve that problem from Rob Herring.
> > I've not yet picked it up into my tree, but I will be doing so soon.
> > For now the dtb needs to be located inside the first 16k of ram.
> >
> > However, it can no longer be based at 0 either.  I discovered that if
> > the dt is based at zero, then the kernel is unable to tell the
> > different between no atags/dtb passed and a dtb passed at physical
> > address 0.  At the very least it needs to be offset about 16 bytes.
> > Since it is common to put atags at address 0x100, it is also
> > reasonable to use 0x100 as the dtb base address too.
> >
> > This problem doesn't exist for machines with ram based at physical
> > address != 0.
> >
> > Sorry I wasn't clear when I posted this.  There is still a bit of flux
> > to get the interface correct and I accidentally glossed over this
> > detail.
> >
> >> The new stuff you added doesn't run early enough to take care of this problem.
> >
> > The problem I was trying to solve is that I was seeing device tree
> > corruption later in the boot process, but it now seems that I might
> > have misdiagnosed it.  I'm still investigation, but I may end up
> > reverting the memblock_reserve() change.
> >
> >>
> >> I probably should have reviewed the patches instead of testing as I
> >> would have realized that.
> >>
> >> I'm looking to see if I can understand how to help the problem.
> >>
> >> Should I really just respond to the mailing list instead of this
> >> back channel?  I don't know good behavior from bad sometimes.
> >
> > Yes, please feel totally free to respond on the mailing list (I went
> > ahead and restored the cc list on this reply).  Just remember to
> > bottom post when replying on-list.
> >
> > g.
> >
> >>


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


