Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab0EMDtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 23:49:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54717 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab0EMDta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 23:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JvPf7yLSVrJsnyeqpccR5XY8Ljm1MrJKROnlNH0Z2Rd7zVYxRs9JzbHiIlaWjGL/2W
         IASrhRub7HZrM1FK0niwo4JEAvWSpcSTtv7ScF/IyP4V0fQbqVqf+E4NpTVTmjV5bEQl
         qxPUEv/s1looYBUdXtC8s17fhqq4b0EVnP2zs=
From: =?utf-8?q?Leonardo=20de=20S=C3=A1=20Alt?= <leonardoaltt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Leonardo=20de=20S=C3=A1=20Alt?= <leonardoaltt@gmail.com>
Subject: [PATCH] FIXED: arch/x86/kernel/hpet.c: /* FIXME: add schedule_work_on() */
Date: Thu, 13 May 2010 00:49:23 -0300
Message-Id: <1273722563-24491-1-git-send-email-leonardoaltt@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed schedule_delayed_work_on for schedule_work_on by using work instead of
delayed work, because the delayed work was used with delay 0.

Signed-off-by: Leonardo de Sá Alt <leonardoaltt@gmail.com>

---
 arch/x86/kernel/hpet.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a198b7c..4516ba1 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -724,12 +724,10 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 
 	switch (action & 0xf) {
 	case CPU_ONLINE:
-		INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
+		INIT_WORK_ON_STACK(&work.work.work, hpet_work);
 		init_completion(&work.complete);
-		/* FIXME: add schedule_work_on() */
-		schedule_delayed_work_on(cpu, &work.work, 0);
+		schedule_work_on(cpu, &work.work.work);
 		wait_for_completion(&work.complete);
-		destroy_timer_on_stack(&work.work.timer);
 		break;
 	case CPU_DEAD:
 		if (hdev) {
-- 
1.6.0.4

