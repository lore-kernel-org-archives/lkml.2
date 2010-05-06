Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0EFPXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:23:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:58405 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792Ab0EFPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:23:44 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L20836-01-HH1-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/7] oprofile/x86: remove CONFIG_SMP macros
Date: Thu, 6 May 2010 15:26:09 +0200
Message-ID: <1273152374-9392-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
References: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU notifier register functions also exist if CONFIG_SMP is
disabled. This change is part of hotplug code rework and also
necessary for later patches.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 2458204..c5df8ee 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -471,7 +471,6 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 	return 0;
 }
 
-#ifdef CONFIG_SMP
 static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
 				 void *data)
 {
@@ -491,7 +490,6 @@ static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
 static struct notifier_block oprofile_cpu_nb = {
 	.notifier_call = oprofile_cpu_notifier
 };
-#endif
 
 #ifdef CONFIG_PM
 
@@ -701,9 +699,8 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		return -ENODEV;
 	}
 
-#ifdef CONFIG_SMP
 	register_cpu_notifier(&oprofile_cpu_nb);
-#endif
+
 	/* default values, can be overwritten by model */
 	ops->create_files	= nmi_create_files;
 	ops->setup		= nmi_setup;
@@ -732,9 +729,7 @@ void op_nmi_exit(void)
 {
 	if (using_nmi) {
 		exit_sysfs();
-#ifdef CONFIG_SMP
 		unregister_cpu_notifier(&oprofile_cpu_nb);
-#endif
 	}
 	if (model->exit)
 		model->exit();
-- 
1.7.0.3


