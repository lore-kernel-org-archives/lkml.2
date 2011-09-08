Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab1IHPHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:07:10 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57301 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1IHPHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:07:08 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] Trivial: devtmpfs.c: No need to set the task state to TASK_RUNNING
Date: Thu,  8 Sep 2011 20:36:28 +0530
Message-Id: <1315494388-2532-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that there should be no need to set the task state to
TASK_RUNNING as wake_up_process will do that for us.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 drivers/base/devtmpfs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index a4760e0..8a3f028 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -416,7 +416,6 @@ static int devtmpfsd(void *p)
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock(&req_lock);
 		schedule();
-		__set_current_state(TASK_RUNNING);
 	}
 	return 0;
 out:
-- 
1.7.4.1

