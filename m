Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2EHKDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:03:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2EHKDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:03:35 -0400
Date: Tue, 8 May 2012 03:03:22 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-c558df4a01a9ec7b02303aba808d1e5044822add@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joerg.roedel@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1336460934-23592-3-git-send-email-suresh.b.siddha@intel.com>
References: <1336460934-23592-3-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] irq_remap: Fix the 'sub_handle'
  uninitialized warning
Git-Commit-ID: c558df4a01a9ec7b02303aba808d1e5044822add
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 03:03:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c558df4a01a9ec7b02303aba808d1e5044822add
Gitweb:     http://git.kernel.org/tip/c558df4a01a9ec7b02303aba808d1e5044822add
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 8 May 2012 00:08:54 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 8 May 2012 11:17:30 +0200

irq_remap: Fix the 'sub_handle' uninitialized warning

Fix this uninitialized variable warning:

  drivers/iommu/intel_irq_remapping.c:986:12: warning: ‘sub_handle’ may be used uninitialized in this function [-Wuninitialized]

GCC is wrong, help it out.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: joro@8bytes.org
Cc: iommu@lists.linux-foundation.org
Cc: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1336460934-23592-3-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/iommu/intel_irq_remapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 1c0255e..6d34706 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -964,7 +964,7 @@ static void intel_compose_msi_msg(struct pci_dev *pdev,
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
-	u16 sub_handle;
+	u16 sub_handle = 0;
 	int ir_index;
 
 	cfg = irq_get_chip_data(irq);
