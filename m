Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2JVVNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:13:13 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:57831 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab2JVVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:13:12 -0400
Date: Mon, 22 Oct 2012 16:10:40 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        John Linn <john.linn@xilinx.com>
Subject: [PATCH v2 0/4] zynq subarch cleanups
Message-ID: <20121022211040.GA31538@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/22/2012 04:10:35 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/22/2012 04:10:35 PM,
	Serialize complete at 10/22/2012 04:10:35 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-22_03:2012-10-22,2012-10-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-

Things have been relatively quiet on the Zynq front lately.  This
patchset does a bit of cleanup of the Zynq subarchitecture.  It was the
necessary set of things I had to do to get a zynq target booting with
the upstream qemu model.  It removes some unused clock infrastructure,
adds DT support for the GIC, and moves around peripheral mappings.

On the CLKDEV_LOOKUP removal: the plan is to rework the out-of-tree
Xilinx generic clk support into something suitable for merging.  What's
in tree now just isn't used at all, and can be removed.

Changes since v1:
  - Make sure arm@kernel.org was included
  - Rebased on arm-soc/for-next
  - Added a cover letter
  - Elaborated a bit on why I removed CLKDEV_LOOKUP

---
Josh Cartwright (4):
  ARM: annotate VMALLOC_END definition with _AC
  zynq: move static peripheral mappings
  zynq: use GIC device tree bindings
  zynq: remove use of CLKDEV_LOOKUP

 arch/arm/Kconfig                           |  1 -
 arch/arm/boot/dts/zynq-ep107.dts           |  8 ++++---
 arch/arm/include/asm/pgtable.h             |  2 +-
 arch/arm/mach-zynq/common.c                | 16 ++++++++-----
 arch/arm/mach-zynq/include/mach/clkdev.h   | 32 --------------------------
 arch/arm/mach-zynq/include/mach/zynq_soc.h | 36 ++++++++++++++++--------------
 6 files changed, 35 insertions(+), 60 deletions(-)
 delete mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h

-- 
1.8.0
