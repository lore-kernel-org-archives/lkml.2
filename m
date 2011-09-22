Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1IVQPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:15:49 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:57453
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219Ab1IVQPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:15:32 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRXMHF-02-J7L-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/10 v2] IOMMU: Make iommu_ops per-bus_type
Date: Thu, 22 Sep 2011 18:14:52 +0200
Message-ID: <1316708102-16250-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

here is the new version of the patch-set to make the iommu_ops used in
the iommu-api a bus_type property. This will allow us to move code out
of the iommu drivers into generic code and it simplifies the
implementation of the Alex' device-group property.

It converts all iommu drivers to use the new registration interface and
completly removes the register_iommu interface.

Greg, can you please look at patch 2 again and let me know if you have
any objections on this version? It think I addressed all your previous
objections.

In case you have no objections and give your Ack we can move on
converting IOMMU drivers to make use of that change and Alex' can move
on with his iommu-groups patch-set :)

Regards,

	Joerg

Changes v1->v2:

	* Added kernel-doc comments to bus_set_iommu function
	* Removed iommu.h include from device.h and added a forward
	  declaration for struct iommu_ops


Diffstat:

 arch/ia64/kvm/kvm-ia64.c           |    3 +-
 arch/x86/kvm/x86.c                 |    3 +-
 drivers/base/bus.c                 |   29 ++++++++++++++++++
 drivers/iommu/amd_iommu.c          |    2 +-
 drivers/iommu/intel-iommu.c        |    2 +-
 drivers/iommu/iommu.c              |   58 ++++++++++++++++++++++++------------
 drivers/iommu/msm_iommu.c          |    2 +-
 drivers/iommu/omap-iommu.c         |    2 +-
 drivers/media/video/omap3isp/isp.c |    2 +-
 include/linux/device.h             |   10 ++++++
 include/linux/iommu.h              |   21 +++++++------
 virt/kvm/iommu.c                   |    4 +-
 12 files changed, 100 insertions(+), 38 deletions(-)


