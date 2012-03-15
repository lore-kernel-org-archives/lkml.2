Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032056Ab2CORkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:40:08 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:52088
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030464Ab2CORkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:40:04 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz146fK4015Izz1202hzzz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0XT2I-02-W69-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 0/9] Introduce irq_remap_ops to x86
Date: Thu, 15 Mar 2012 18:39:42 +0100
Message-ID: <1331833191-25779-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in order to implement interrupt remapping using the AMD IOMMU I did some
refactoring of the current Intel-specific interrupt remapping code. The
result is posted for comments in this patch-set.

The patch-set basically removes the Intel-specific calls from the X86
apic and io-apic code and replaces all of them with helper functions
that use the irq_remap_ops to hook into an implementation specific
implementation.

I have done basic testing on this patch-set on a VT-d machine with
interrupt remapping and found no regression so far. But as usual this
doesn't mean that there is none ;-)

Anyway, since I am on vacation soon I sent out these patches to receive
all kinds of comments so that I can start over to add the AMD part when
I am back.

Thanks,

	Joerg

Diffstat:

 arch/ia64/include/asm/intr_remapping.h |    4 +
 arch/x86/include/asm/intr_remapping.h  |  101 +++
 arch/x86/include/asm/irq_remapping.h   |   45 --
 arch/x86/kernel/apic/apic.c            |   20 +-
 arch/x86/kernel/apic/io_apic.c         |  276 ++-------
 drivers/iommu/Makefile                 |    2 +-
 drivers/iommu/amd_iommu_init.c         |  123 +++--
 drivers/iommu/dmar.c                   |    1 +
 drivers/iommu/intel-iommu.c            |    1 +
 drivers/iommu/intel_intr_remapping.c   | 1065 ++++++++++++++++++++++++++++++++
 drivers/iommu/intr_remapping.c         |  810 +++----------------------
 drivers/iommu/intr_remapping.h         |   97 +++-
 include/linux/amd-iommu.h              |    2 +-
 include/linux/dmar.h                   |   85 ---
 14 files changed, 1469 insertions(+), 1163 deletions(-)


