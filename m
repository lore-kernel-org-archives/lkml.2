Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1ARWjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:39:36 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40191 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1ARWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:39:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QL5wg07uGLpeziy4j92pVzT80QGZfeOQTdlmnhwERiDwTJfh63HDCcT1mXpi+j5+ao
         0zcKjVKxH8DP9q/5rd5RUQt5fGIa+Snu2zm5opYT6IH2VV9iiSfs7/yE2muNu+86R+Uj
         4fdPip09/G9X2Qj1LHOOr2KsSjM/fdJpIx3fY=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org
Subject: [PATCH 3/3] watchdog: don't change watchdog state on read of sysctl
Date: Tue, 18 Jan 2011 23:37:46 +0100
Message-Id: <1295390266-9347-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org
---
 kernel/watchdog.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 9f24056..0e2776e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -486,10 +486,11 @@ int proc_dowatchdog_enabled(struct ctl_table *table, int write,
 {
 	proc_dointvec(table, write, buffer, length, ppos);
 
-	if (watchdog_enabled)
-		watchdog_enable_all_cpus();
-	else
-		watchdog_disable_all_cpus();
+	if (write)
+		if (watchdog_enabled)
+			watchdog_enable_all_cpus();
+		else
+			watchdog_disable_all_cpus();
 	return 0;
 }
 
-- 
1.7.3.3

