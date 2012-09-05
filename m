Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab2IELAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:00:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2IELAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:00:17 -0400
Date: Wed, 5 Sep 2012 04:00:05 -0700
From: tip-bot for Mathias Krause <minipli@googlemail.com>
Message-ID: <tip-ae13b7b4e041eccf34fa4dd58581fe1441375578@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joerg.roedel@amd.com, minipli@googlemail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, minipli@googlemail.com, tglx@linutronix.de
In-Reply-To: <1346621506-30857-8-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-8-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/iommu:
  Use NULL instead of plain 0 for __IOMMU_INIT
Git-Commit-ID: ae13b7b4e041eccf34fa4dd58581fe1441375578
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 04:00:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae13b7b4e041eccf34fa4dd58581fe1441375578
Gitweb:     http://git.kernel.org/tip/ae13b7b4e041eccf34fa4dd58581fe1441375578
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Sun, 2 Sep 2012 23:31:46 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:52:26 +0200

x86/iommu: Use NULL instead of plain 0 for __IOMMU_INIT

IOMMU_INIT_POST and IOMMU_INIT_POST_FINISH pass the plain value
0 instead of NULL to __IOMMU_INIT. Fix this and make sparse
happy by doing so.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1346621506-30857-8-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/iommu_table.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index bbf8fb2..f42a047 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -63,10 +63,10 @@ struct iommu_table_entry {
  * to stop detecting the other IOMMUs after yours has been detected.
  */
 #define IOMMU_INIT_POST(_detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 0)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  NULL, NULL, 0)
 
 #define IOMMU_INIT_POST_FINISH(detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 1)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  NULL, NULL, 1)
 
 /*
  * A more sophisticated version of IOMMU_INIT. This variant requires:
