Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2ISDSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:18:33 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48173 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752Ab2ISDSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:18:30 -0400
From: hongfeng <hongfeng@marvell.com>
To: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, gregkh@linuxfoundation.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        hongfeng <hongfeng@marvell.com>, Raul Xiong <xjian@marvell.com>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] PM / Sleep: use resume event when call dpm_resume_early
Date: Wed, 19 Sep 2012 11:17:54 +0800
Message-Id: <1348024674-13050-1-git-send-email-hongfeng@marvell.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 19 Sep 2012 03:18:07.0100 (UTC) FILETIME=[637983C0:01CD9615]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dpm_suspend_noirq fail, state is PMSG_SUSPEND,
should change to PMSG_RESUME when dpm_resume_early is called

Change-Id: If815218d4934b4648e330235ab1ae26e713284bd
Signed-off-by: Feng Hong <hongfeng@marvell.com>
Signed-off-by: Raul Xiong <xjian@marvell.com>
Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/base/power/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 0113adc..2700f2e 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -996,7 +996,7 @@ int dpm_suspend_end(pm_message_t state)
 
 	error = dpm_suspend_noirq(state);
 	if (error) {
-		dpm_resume_early(state);
+		dpm_resume_early(resume_event(state));
 		return error;
 	}
 
-- 
1.7.0.4

