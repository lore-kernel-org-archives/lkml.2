Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1APFmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 00:42:38 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21643 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1APFmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 00:42:36 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG8UMk2rR7Hu/2dsb2JhbACkaXOkVJgahVAEhHCGLw
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [SCSI] target: Fix memory leak on error path
X-Message-Flag: Warning: May contain useful information
Date: Sat, 15 Jan 2011 21:42:32 -0800
Message-ID: <ada1v4d1k1j.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If allocation of pt->pscsi_cdb fails, we need to free the just-allocated
pt or else it will be leaked.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/target/target_core_pscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 742d246..60a2509 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -817,6 +817,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
 		if (!(pt->pscsi_cdb)) {
 			printk(KERN_ERR "pSCSI: Unable to allocate extended"
 					" pt->pscsi_cdb\n");
+			kfree(pt);
 			return NULL;
 		}
 	} else
