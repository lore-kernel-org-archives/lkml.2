Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab0HDVOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:14:02 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:53985 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759005Ab0HDVNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:13:55 -0400
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCHv3 02/16] pps: declare variables where they are used in switch
Date: Thu,  5 Aug 2010 01:06:39 +0400
Message-Id: <499466fe6558d89bff6092768c57e5c928d99b13.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move variable declarations where they are used in pps_cdev_ioctl.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/pps.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index ca5183b..c76afb9 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -61,8 +61,6 @@ static long pps_cdev_ioctl(struct file *file,
 {
 	struct pps_device *pps = file->private_data;
 	struct pps_kparams params;
-	struct pps_fdata fdata;
-	unsigned long ticks;
 	void __user *uarg = (void __user *) arg;
 	int __user *iuarg = (int __user *) arg;
 	int err;
@@ -136,7 +134,9 @@ static long pps_cdev_ioctl(struct file *file,
 
 		break;
 
-	case PPS_FETCH:
+	case PPS_FETCH: {
+		struct pps_fdata fdata;
+
 		pr_debug("PPS_FETCH: source %d\n", pps->id);
 
 		err = copy_from_user(&fdata, uarg, sizeof(struct pps_fdata));
@@ -149,6 +149,8 @@ static long pps_cdev_ioctl(struct file *file,
 		if (fdata.timeout.flags & PPS_TIME_INVALID)
 			err = wait_event_interruptible(pps->queue, pps->go);
 		else {
+			unsigned long ticks;
+
 			pr_debug("timeout %lld.%09d\n",
 					(long long) fdata.timeout.sec,
 					fdata.timeout.nsec);
@@ -185,7 +187,7 @@ static long pps_cdev_ioctl(struct file *file,
 			return -EFAULT;
 
 		break;
-
+	}
 	default:
 		return -ENOTTY;
 		break;
-- 
1.7.1

