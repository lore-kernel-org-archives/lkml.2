Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab1ECJzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:55:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47302 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1ECJzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=aSAdIVXe+XrckOb94sm8evG1o4U7xrKu/t+zlUMhqGHedraW4JIsmUhm2Ytn/gtPUD
         nhtJJ5OWqr/+LZGW9sA0/88gPmTkWNkqN3+pv18wSSBrAik4shjHRzxr+9sT1YxF59Ib
         eE0nK6rSD7HhFwSidsQYvUTGgOeKuC+kQJHuE=
From: "Cho, Yu-Chen" <acho@novell.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
        wei_wang@realsil.com.cn
Cc: segoon@openwall.com, a.beregalov@gmail.com, jlee@novell.com,
        acho@novell.com
Subject: [PATCH] staging/rts_pstor: fix Polling thread wakeups CPU
Date: Tue,  3 May 2011 17:53:35 +0800
Message-Id: <ef04e68f674a4175dccdb7f4cf04f419199051b6.1304415652.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RealTek PCI-E Card Reader rts_pstor driver causes CPU wakeup very
frequently, thatt's bad for power consumption.

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/rts_pstor/rtsx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 02525d5..5ff59f2 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -594,7 +594,9 @@ static int rtsx_polling_thread(void *__dev)
 	wait_timeout((delay_use + 5) * 1000);
 
 	for (;;) {
-		wait_timeout(POLLING_INTERVAL);
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(POLLING_INTERVAL);
 
 		/* lock the device pointers */
 		mutex_lock(&(dev->dev_mutex));
-- 
1.7.1

