Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2ASOaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:30:21 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:18106
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751867Ab2ASOaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:30:17 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY1UY6-01-0KB-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: [PATCH 0/5] IOMMU: Make IOMMU-API ready for GART-like hardware
Date: Thu, 19 Jan 2012 15:30:00 +0100
Message-ID: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch-set adds two new functions the the IOMMU-API:

	* iommu_domain_set_attr()
	* iommu_domain_get_attr()

These are generic functions to set and change attributes of a domain.
The plan is to have a set of generic attributes implemented by more than
one IOMMU driver as well as driver specific ones. As an example for the
first type this patch-set also implements the DOMAIN_ATTR_GEOMETRY
attribute. It can be used to query information about the address space
window that can be remapped by the iommu hardware. With this attribute
is is very easy to support IOMMUs like GART and friends.

Any feedback appreciated.

Thanks,

	Joerg

Diffstat:
	
 drivers/iommu/amd_iommu.c   |    4 ++++
 drivers/iommu/intel-iommu.c |    4 ++++
 drivers/iommu/iommu.c       |   33 +++++++++++++++++++++++++++++++++
 drivers/iommu/msm_iommu.c   |    5 +++++
 drivers/iommu/omap-iommu.c  |    4 ++++
 include/linux/iommu.h       |   36 +++++++++++++++++++++++++++++++++++-
 6 files changed, 85 insertions(+), 1 deletions(-)


