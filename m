Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1DGNaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:30:15 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:45714
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751702Ab1DGNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:13 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU6-01-CQ9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] Rework command handling of AMD IOMMU driver
Date: Thu, 7 Apr 2011 15:29:55 +0200
Message-ID: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch-set reworks the command handling in the AMD IOMMU driver. The
functions are better named now and more clearly splitted. Some cases are
also better handled now than before, like the situation of congestion in
the command buffer.

To further increase maintainability the driver now flushes all internal
caches of the IOMMU right after it gets enabled and does not rely on
flushing individual caches before they are used.

Any feedback appreciated.

Regards,

	Joerg

Diffstat:

 arch/x86/include/asm/amd_iommu_proto.h |    2 -
 arch/x86/include/asm/amd_iommu_types.h |    3 -
 arch/x86/kernel/amd_iommu.c            |  415 +++++++++++++++-----------------
 arch/x86/kernel/amd_iommu_init.c       |   11 +-
 4 files changed, 202 insertions(+), 229 deletions(-)

Shortlog:

Joerg Roedel (9):
      x86/amd-iommu: Move compl-wait command building to own function
      x86/amd-iommu: Move inv-dte command building to own function
      x86/amd-iommu: Cleanup inv_pages command handling
      x86/amd-iommu: Cleanup completion-wait handling
      x86/amd-iommu: Remove command buffer resetting logic
      x86/amd-iommu: Rename iommu_flush* to domain_flush*
      x86/amd-iommu: Improve handling of full command buffer
      x86/amd-iommu: Rename iommu_flush_device
      x86/amd-iommu: Flush all internal TLBs when IOMMUs are enabled


