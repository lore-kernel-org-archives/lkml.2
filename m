Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859Ab0HDVPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:15:01 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:54005 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab0HDVN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:13:58 -0400
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv3 01/16] pps: trivial fixes
Date: Thu,  5 Aug 2010 01:06:38 +0400
Message-Id: <94867e6226b5d6dd7231a829a2752232fe3a5ca2.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some very trivial fixes combined:
 * add macro definitions to protect header file from including several times
 * remove declaration for an unexistent array
 * fix typos

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/kapi.c         |    2 +-
 include/linux/pps_kernel.h |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 1aa02db..55f3961 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -324,7 +324,7 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 		captured = ~0;
 	}
 
-	/* Wake up iif captured somthing */
+	/* Wake up if captured something */
 	if (captured) {
 		pps->go = ~0;
 		wake_up_interruptible(&pps->queue);
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index e0a193f..c930d11 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -18,6 +18,9 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#ifndef LINUX_PPS_KERNEL_H
+#define LINUX_PPS_KERNEL_H
+
 #include <linux/pps.h>
 
 #include <linux/cdev.h>
@@ -71,7 +74,6 @@ struct pps_device {
 
 extern spinlock_t pps_idr_lock;
 extern struct idr pps_idr;
-extern struct timespec pps_irq_ts[];
 
 extern struct device_attribute pps_attrs[];
 
@@ -87,3 +89,6 @@ extern void pps_unregister_source(int source);
 extern int pps_register_cdev(struct pps_device *pps);
 extern void pps_unregister_cdev(struct pps_device *pps);
 extern void pps_event(int source, struct pps_ktime *ts, int event, void *data);
+
+#endif /* LINUX_PPS_KERNEL_H */
+
-- 
1.7.1

