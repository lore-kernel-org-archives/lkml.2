Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1AZUGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:06:15 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:46514
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab1AZUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:06:08 -0500
X-SpamScore: -23
X-BigFish: VPS-23(zz936eK542N1432N9371Pzz1202hzz8275bh8275dhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [PATCH 0/8] Basic ARM device tree support
Date: Wed, 26 Jan 2011 13:04:39 -0700
In-Reply-To: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/8] Basic ARM device tree support
Thread-Index: Acu3TlqtqJz01U+qTCG08q+v81ig3QGRO9FA
References: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
From: John Linn <John.Linn@xilinx.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
X-OriginalArrivalTime: 26 Jan 2011 20:04:39.0709 (UTC) FILETIME=[4398D4D0:01CBBD94]
X-RCIS-Action: ALLOW
Message-ID: <00bcd596-2108-4c54-92d3-7fda39e333e3@VA3EHSMHS015.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0QK6Muj014680

> -----Original Message-----
> From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> Sent: Tuesday, January 18, 2011 1:29 PM
> To: linux-arm-kernel@lists.infradead.org
> Cc: Nicolas Pitre; Russell King; Catalin Marinas; devicetree-discuss@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; Olof Johansson; Jeremy Kerr; John Linn; Lennert Buijtenhek
> Subject: [PATCH 0/8] Basic ARM device tree support
> 
> It's been a while since these patches have been circulated for review.
> Much has changed since the last posting and there are no longer any
> ugly hacks or workarounds to it working.  From my viewpoint, these
> patches are complete and ready to be used.
> 
> This patch series allows CONFIG_OF to be enabled on ARM and allows the
> kernel to accept a dtb pointer from boot firmware instead of atags.
> If a dtb is passed, then the kernel will use the root 'compatible'
> property to find a matching machine_desc, and it will use it to obtain
> the memory layout, initrd location and kernel parameters string.
> 
> Only limited device tree support is enabled here.  It does not perform
> any kind of device registration from device tree data.  That support
> will be enabled in a later patch set.  Right now those patches depend
> on the common struct clk patches that Jeremy is working on, so I'm not
> going to post them yet.  Rather, this series is a stable base that
> other engineers can use to start working on device tree support for
> their platforms.
> 
> Tested on Versatile (qemu) and nVidia Tegra Harmony.  Kernel compiles
> an boot with CONFIG_OF both on and off, both with and without passing
> a device tree blob.

Tested on Xilinx platform.  Did see an issue with loading the device
tree blob into higher memory.  At address 0 there was no issue.  

> 
> I've published this series to a new branch on my git server:
> 
>   git://git.secretlab.ca/git/linux-2.6 devicetree/arm
> 
> The way I've managed the devicetree/test branch in the past has made
> it hard for other engineers to work with the device tree support, so
> I'm changing the way I'm handling it.  I will *not* rebase this new
> branch.  My intention is to keep it in essentially 'merge-ready' state
> at all times.  ie. I'm only going to put patches into this branch that
> I consider complete and are required to enable arm device tree
> support.  ie. core dt infrastructure and dt board support.  Device
> drivers should be submitted directly to their respective
> lists/maintainers.  I'll also be soliciting acks from platform
> maintainers before I pick up board support patches into this branch.
> 
> Russell:  I'm not expecting you to merge these now, nor am I asking
> you to.  I won't do so until I've got a full implementation using the
> device tree to register devices on the machine and supporting multiple
> machines.  However, would you mind taking a look at these patches and
> commenting on the approach?  Particularly the early boot code.
> Thanks.
> 
> Cheers,
> g.
> 

Thanks for this patch set.  Device tree on ARM will be a great help to Xilinx.

Tested-by: John Linn <john.linn@xilinx.com>

> 
> ---
> The following changes since commit
> a25cecce88194b2edf38b8c3b1665e9318eb2d22:
> 
>   Merge branch 'next' of git://git.monstr.eu/linux-2.6-microblaze (2011-01-18 08:06:22 -0800)
> 
> are available in the git repository at:
> 
>   git://git.secretlab.ca/git/linux-2.6 devicetree/arm
> 
> Grant Likely (7):
>       arm/dt: Make __vet_atags also accept a dtb image
>       arm/dt: allow bootmem reservation for device tree blob and initrd
>       arm/dt: consolidate atags setup into setup_machine_atags
>       arm/dt: probe for platforms via the device tree
>       arm/dt: Basic versatile devicetree support
>       arm/tegra: Fix tegra irq_data conversion
>       arm/dt: Basic tegra devicetree support
> 
> Jeremy Kerr (1):
>       arm/dt: Allow CONFIG_OF on ARM
> 
> 
>  arch/arm/Kconfig                       |    7 ++
>  arch/arm/include/asm/mach/arch.h       |    2 +
>  arch/arm/include/asm/prom.h            |   34 ++++++++++
>  arch/arm/include/asm/setup.h           |    4 +
>  arch/arm/kernel/Makefile               |    1
>  arch/arm/kernel/devtree.c              |  107 ++++++++++++++++++++++++++++++++
>  arch/arm/kernel/head-common.S          |   19 ++++--
>  arch/arm/kernel/head.S                 |    8 +-
>  arch/arm/kernel/setup.c                |   78 +++++++++++++----------
>  arch/arm/mach-tegra/board-harmony.c    |    6 ++
>  arch/arm/mach-tegra/gpio.c             |    4 +
>  arch/arm/mach-versatile/versatile_ab.c |    6 ++
>  arch/arm/mach-versatile/versatile_pb.c |    6 ++
>  arch/arm/mm/init.c                     |   23 +++++++
>  14 files changed, 258 insertions(+), 47 deletions(-)
>  create mode 100644 arch/arm/include/asm/prom.h
>  create mode 100644 arch/arm/kernel/devtree.c
> 
> --
> Signature


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
