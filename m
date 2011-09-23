Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1IWPtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:49:23 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:5146
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754908Ab1IWPsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:48:55 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRZFSQ-01-1CS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/10 v3] IOMMU: Make iommu_ops per-bus_type
Date: Fri, 23 Sep 2011 17:45:46 +0200
Message-ID: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the third version of the patch-set to make the iommu_ops used in
the iommu-api a bus_type property. This will allow us to move code out
of the iommu drivers into generic code and it simplifies the
implementation of the Alex' device-group property.

It converts all iommu drivers to use the new registration interface and
completly removes the register_iommu interface.

Please let me know of any remaining objections. If there are no I would
be very happy about Acked-By's :)

Regards,

	Joerg

Changes v2->v3:
	* Moved bus_set_iommu() to drivers/iommu/iommu.c to get rid of
	  the CONFIG_IOMMU_API #ifdef around it in bus.c

Changes v1->v2:

        * Added kernel-doc comments to bus_set_iommu function
        * Removed iommu.h include from device.h and added a forward
          declaration for struct iommu_ops

Diffstat:

 arch/ia64/kvm/kvm-ia64.c           |    3 +-
 arch/x86/kvm/x86.c                 |    3 +-
 drivers/iommu/amd_iommu.c          |    2 +-
 drivers/iommu/intel-iommu.c        |    2 +-
 drivers/iommu/iommu.c              |   81 ++++++++++++++++++++++++++++--------
 drivers/iommu/msm_iommu.c          |    2 +-
 drivers/iommu/omap-iommu.c         |    2 +-
 drivers/media/video/omap3isp/isp.c |    2 +-
 include/linux/device.h             |    6 +++
 include/linux/iommu.h              |   21 +++++----
 virt/kvm/iommu.c                   |    4 +-
 11 files changed, 92 insertions(+), 36 deletions(-)


