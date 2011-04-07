Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1DGNae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:30:34 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:6414 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1DGNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:25 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU7-01-CQD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/9] x86/amd-iommu: Move compl-wait command building to own function
Date: Thu, 7 Apr 2011 15:29:56 +0200
Message-ID: <1302183004-4081-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
References: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a seperate function for building
completion-wait commands.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 57ca777..eebd504 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -383,6 +383,13 @@ irqreturn_t amd_iommu_int_handler(int irq, void *data)
  *
  ****************************************************************************/
 
+static void build_completion_wait(struct iommu_cmd *cmd)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[0] = CMD_COMPL_WAIT_INT_MASK;
+	CMD_SET_TYPE(cmd, CMD_COMPL_WAIT);
+}
+
 /*
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command. Must be called with iommu->lock held.
@@ -458,9 +465,7 @@ static int __iommu_completion_wait(struct amd_iommu *iommu)
 {
 	struct iommu_cmd cmd;
 
-	 memset(&cmd, 0, sizeof(cmd));
-	 cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
-	 CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
+	build_completion_wait(&cmd);
 
 	 return __iommu_queue_command(iommu, &cmd);
 }
-- 
1.7.1


