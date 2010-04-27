Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0D0SAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:00:37 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:23719 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab0D0SAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:00:33 -0400
X-Spam-Processed: digidescorp.com, Tue, 27 Apr 2010 13:00:33 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1733b75585=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH][NOMMU] microblaze: re-enable interrupts before calling schedule
Date: Tue, 27 Apr 2010 13:00:23 -0500
Message-Id: <1272391223-32012-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule() should not be called with interrupts disabled.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
--- a/arch/microblaze/kernel/entry-nommu.S	2010-04-27 10:14:33.000000000 -0500
+++ b/arch/microblaze/kernel/entry-nommu.S	2010-04-27 12:53:04.000000000 -0500
@@ -476,6 +476,8 @@ ENTRY(ret_from_fork)
 	nop
 
 work_pending:
+	enable_irq
+
 	andi	r11, r19, _TIF_NEED_RESCHED
 	beqi	r11, 1f
 	bralid	r15, schedule

