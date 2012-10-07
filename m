Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab2JGFWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 01:22:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2JGFWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 01:22:14 -0400
Date: Sun, 7 Oct 2012 07:24:58 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH v4 -tip 0/3] x86, MSI, AHCI: Support multiple MSIs
Message-ID: <cover.1349517905.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Compared to v3:

	Based on Ingo's review:

	I have not noticed that v3 2/5 patch "x86, MSI: Allocate as many
	multiple IRQs as requested" is redundant, since the AHCI code
	tries to allocate maximum possible number of MSIs. As there are
	no other users of this functionality, I removed the patch for now;

	v3 patch 3/5 "x86, MSI: Minor readability fixes" merged into
  	v4 patch 1/3 "x86, MSI: Support multiple MSIs in presense of IRQ
	remapping";

	1,3/3:	multi-line comments fixed;
		loops 'for (; i; i--)' changed to 'for (i--; i >= 0; i--)';

	3/3:	ahci_host_activate() failure path tested;
		ahci_port_priv::lock field commented;


Alexander Gordeev (3):
  1/3 x86, MSI: Support multiple MSIs in presense of IRQ remapping
  2/3 PCI, MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
  3/3 AHCI: Support multiple MSIs

 Documentation/PCI/MSI-HOWTO.txt |   37 ++++++++-
 arch/x86/kernel/apic/io_apic.c  |  165 +++++++++++++++++++++++++++++++--------
 drivers/ata/ahci.c              |   93 +++++++++++++++++++++-
 drivers/ata/ahci.h              |    6 ++
 drivers/ata/libahci.c           |  118 ++++++++++++++++++++++++++--
 drivers/pci/msi.c               |   26 ++++++
 include/linux/irq.h             |    5 +
 include/linux/pci.h             |    7 ++
 kernel/irq/chip.c               |   30 +++++--
 9 files changed, 432 insertions(+), 55 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
