Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1FOVqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:46:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:18392 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab1FOVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:46:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,371,1304319600"; 
   d="scan'208";a="14007390"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [staging] staging/mei: fix possible usage of uninitialized variable
Date: Thu, 16 Jun 2011 00:46:03 +0300
Message-Id: <1308174363-18876-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning: reported in http://marc.info/?l=linux-kernel&m=130812960402606&w=2

drivers/staging/mei/interrupt.c: warning: 'buffer' may be used uninitialized in this function:  => 198

It is a real issue and wrong path in execution is taken when
list is empty or (cl && _mei_irq_thread_state_ok(cl, mei_hdr))
evaluates to false

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
This patch should be considered for 3.0

 drivers/staging/mei/interrupt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 2ff30ee..9cb186b 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -195,7 +195,7 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 {
 	struct mei_cl *cl;
 	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
-	unsigned char *buffer;
+	unsigned char *buffer = NULL;
 
 	dev_dbg(&dev->pdev->dev, "start client msg\n");
 	if (!(dev->read_list.status == 0 &&
-- 
1.7.4.4

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

