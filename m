Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab2JXAc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:32:28 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:37986 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546Ab2JXAc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:32:27 -0400
Date: Tue, 23 Oct 2012 19:32:18 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: [PATCH v3 0/5] zynq subarch cleanups
Message-ID: <20121024003218.GA31625@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 07:32:14 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 07:32:14 PM,
	Serialize complete at 10/23/2012 07:32:14 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-23_09:2012-10-23,2012-10-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-

Things have been relatively quiet on the Zynq front lately.  This patchset does
a bit of cleanup of the Zynq subarchitecture.  It was the necessary set of
things I had to do to get a zynq target booting with the upstream qemu model.

Patches 1 and 2 move zynq to use the GIC and pl310 L2 cache controller device
tree mappings respectively.

Patch 3 removes unused clock infrastructure.  the plan is to rework the
out-of-tree Xilinx generic clk support into something suitable for merging.
What's in tree now just isn't used at all, and can be removed.

Patch 4 and 5 move around the static peripheral mappings into the vmalloc area.

Arnd-

I intentionally did not Cc stable on patch 5, even though you had
suggested otherwise.  I do not think it will apply cleanly to the stable
trees independent of the other patches.  Additionally, with the current
state of zynq upstream, I'm not convinced there would be enough users to
make it worth the effort.

Additionally, I've left the SCU static mapping around, even though its
currently unused.  We'll eventually need it around (maybe in a different form)
when SMP support is added.

---
Changes since v2:
  - Reordered patchset to prevent remapping peripherals that were subsequently
    removed from the static map
  - Use DT bindings for the L2 cache controller

Changes since v1:
  - Make sure arm@kernel.org was included
  - Rebased on arm-soc/for-next
  - Added a cover letter
  - Elaborated a bit on why I removed CLKDEV_LOOKUP

---
Josh Cartwright (5):
  zynq: use GIC device tree bindings
  zynq: use pl310 device tree bindings
  zynq: remove use of CLKDEV_LOOKUP
  ARM: annotate VMALLOC_END definition with _AC
  zynq: move static peripheral mappings

 arch/arm/Kconfig                           |  1 -
 arch/arm/boot/dts/zynq-ep107.dts           | 17 +++++++++++++---
 arch/arm/include/asm/pgtable.h             |  2 +-
 arch/arm/mach-zynq/common.c                | 23 ++++++++++-----------
 arch/arm/mach-zynq/include/mach/clkdev.h   | 32 ------------------------------
 arch/arm/mach-zynq/include/mach/zynq_soc.h | 29 ++++++++++++---------------
 6 files changed, 38 insertions(+), 66 deletions(-)
 delete mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h

-- 
1.8.0
