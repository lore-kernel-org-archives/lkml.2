Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab2C1Ath (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:49:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:51417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab2C1Ark (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125867364"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        balbi@ti.com, gregkh@linuxfoundation.org
Subject: [PATCH 09/13] usb: gadget: f_fs: Remove lock is held before freeing checks
Date: Tue, 27 Mar 2012 17:47:13 -0700
Message-Id: <1332895637-32572-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

lock debugging already supports this, no need to do it explicitely.

Cc: balbi@ti.com
Cc: gregkh@linuxfoundation.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/usb/gadget/f_fs.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index f63dc6c..c5e8994 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1258,9 +1258,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 	if (unlikely(atomic_dec_and_test(&ffs->ref))) {
 		pr_info("%s(): freeing\n", __func__);
 		ffs_data_clear(ffs);
-		BUG_ON(mutex_is_locked(&ffs->mutex) ||
-		       spin_is_locked(&ffs->ev.waitq.lock) ||
-		       waitqueue_active(&ffs->ev.waitq) ||
+		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
 		       waitqueue_active(&ffs->ep0req_completion.wait));
 		kfree(ffs);
 	}
-- 
1.7.7.6

