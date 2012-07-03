Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2GCJIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:08:54 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:52170 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755718Ab2GCJIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:08:51 -0400
From: Xiaoguang Chen <chenxg@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, mturquette@ti.com,
        axel.lin@gmail.com, Xiaoguang Chen <chenxg@marvell.com>
Subject: [PATCH] PM: Devfreq: fix userspace governor frequency bug
Date: Tue,  3 Jul 2012 17:08:34 +0800
Message-Id: <1341306514-19173-1-git-send-email-chenxg@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 03 Jul 2012 09:08:37.0454 (UTC) FILETIME=[6E525EE0:01CD58FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The frequency set by userspace governor may not the
same as the final frequency. If this condition happens,
then "cat set_freq" will return a wrong value which is
inconsistant with the real frequency.

This patch updates data->user_frequency after calling
of update_devfreq. use devfreq->revious_freq as the
final user_frequency.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
---
 drivers/devfreq/governor_userspace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
index 0681246..85ad80a 100644
--- a/drivers/devfreq/governor_userspace.c
+++ b/drivers/devfreq/governor_userspace.c
@@ -59,6 +59,7 @@ static ssize_t store_freq(struct device *dev, struct device_attribute *attr,
 	err = update_devfreq(devfreq);
 	if (err == 0)
 		err = count;
+	data->user_frequency = devfreq->previous_freq;
 	mutex_unlock(&devfreq->lock);
 	return err;
 }
-- 
1.7.0.4

