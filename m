Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab1IVPuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:50:08 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:9957
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab1IVPuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:50:02 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRXLA7-02-GC1-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Support for PRI and PASID capability
Date: Thu, 22 Sep 2011 17:49:07 +0200
Message-ID: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

here is a patch-set that enables support for the PRI and PASID
capabilities in the Linux PCI core. These capabilities of a PCIe device
are tightly coupled with ATS, but not with IOV. So these patches start
by moving the ATS code into its own file: ats.c.

Support for the other two capabilities is based on that change. Please
review the patches and let me know of any objections you might have.

Thanks,

	Joerg

Diffstat:

 drivers/pci/Kconfig      |   24 +++
 drivers/pci/Makefile     |    1 +
 drivers/pci/ats.c        |  438 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/iov.c        |  142 ---------------
 include/linux/pci-ats.h  |   75 ++++++++
 include/linux/pci_regs.h |   20 ++
 6 files changed, 558 insertions(+), 142 deletions(-)


