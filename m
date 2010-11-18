Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0KRQHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:07:40 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:37453 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab0KRQHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:07:33 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv4 01/17] pps: trivial fixes
Date: Thu, 18 Nov 2010 19:00:54 +0300
Message-Id: <16bd98f4fdaf4fecae734a099d2d116f67622b21.1290087475.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some very trivial fixes combined:
 * add macro definitions to protect header file from including several times
 * remove declaration for an unexistent array
 * fix typos

Acked-by: Rodolfo Giometti <giometti@linux.it>
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
1.7.2.3

