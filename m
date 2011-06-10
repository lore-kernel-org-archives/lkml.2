Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1FJMKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:10:02 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:34254
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755990Ab1FJMIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:08:31 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275dhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ1-01-6LQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] AMD IOMMU: Reduce dependency to struct device
Date: Fri, 10 Jun 2011 14:08:40 +0200
Message-ID: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series reduces the dependency of the AMD IOMMU driver to the
struct device. In fact, it removes the dependency that every request id
the IOMMU can see must have a PCI device in the system. So this is the
real fix for

	https://bugzilla.kernel.org/show_bug.cgi?id=35592

Any (constructive) feedback appreciated!

Regards,

	Joerg

Diffstat:

 arch/x86/include/asm/amd_iommu_types.h |    9 +-
 arch/x86/kernel/amd_iommu.c            |  291 ++++++++++++++++++--------------
 2 files changed, 175 insertions(+), 125 deletions(-)

Shortlog:

Joerg Roedel (9):
      x86/amd-iommu: Remove redundant device_flush_dte() calls
      x86/amd-iommu: Introduce global dev_data_list
      x86/amd-iommu: Store devid in dev_data
      x86/amd-iommu: Store ATS state in dev_data
      x86/amd-iommu: Use only dev_data for dte and iotlb flushing routines
      x86/amd-iommu: Use only dev_data in low-level domain attach/detach functions
      x86/amd-iommu: Allow dev_data->alias to be NULL
      x86/amd-iommu: Search for existind dev_data before allocting a new one
      x86/amd-iommu: Store device alias as dev_data pointer


