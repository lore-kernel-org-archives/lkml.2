Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1IGQ3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:29:15 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:52632
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab1IGQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:29:07 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR5SXT-02-DW1-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/10] IOMMU: Make iommu_ops per-bus_type
Date: Wed, 7 Sep 2011 17:41:43 +0200
Message-ID: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the new version of the patch-set to make the iommu_ops used in
the iommu-api a bus_type property. This will allow us to move code out
of the iommu drivers into generic code and it simplifies the
implementation of the Alex' device-group property.

Greg, can you have a look at patch 2 please and tell me if you have any
objections?

With this version the patch-set is complete (not as the first RFC post).
It converts all iommu drivers to use the new registration interface and
completly removes the register_iommu interface.

Regards,

	Joerg

Diffstat:

 arch/ia64/kvm/kvm-ia64.c           |    3 +-
 arch/x86/kvm/x86.c                 |    3 +-
 drivers/base/bus.c                 |   16 ++++++++++
 drivers/iommu/amd_iommu.c          |    2 +-
 drivers/iommu/intel-iommu.c        |    2 +-
 drivers/iommu/iommu.c              |   58 ++++++++++++++++++++++++------------
 drivers/iommu/msm_iommu.c          |    2 +-
 drivers/iommu/omap-iommu.c         |    2 +-
 drivers/media/video/omap3isp/isp.c |    2 +-
 include/linux/device.h             |    9 +++++
 include/linux/iommu.h              |   21 +++++++------
 virt/kvm/iommu.c                   |    4 +-
 12 files changed, 86 insertions(+), 38 deletions(-)


