Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031271Ab2ERXZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:25:55 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53056 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031249Ab2ERXZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:25:49 -0400
Subject: [PATCH 0/2] iommu: request CSR space
To: David Woodhouse <dwmw2@infradead.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
Date: Fri, 18 May 2012 17:18:26 -0600
Message-ID: <20120518231238.31187.44571.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a request_mem_region() for the DRHD registers.  The AMD
code has similar code in iommu_map_mmio_space().

This helps avoid address conflicts when assigning PCI BARs.

---

Bjorn Helgaas (2):
      resources: set type of new resource returned by __request_region()
      iommu: Request IOMMU CSR space


 drivers/iommu/dmar.c        |   41 ++++++++++++++++++++++++++++++++---------
 include/linux/intel-iommu.h |    2 ++
 kernel/resource.c           |    3 ++-
 3 files changed, 36 insertions(+), 10 deletions(-)
