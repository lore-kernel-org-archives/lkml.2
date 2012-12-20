Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2LTTQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:16:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21848 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2LTTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:32 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] um: don't compare a pointer to 0
Date: Thu, 20 Dec 2012 14:11:35 -0500
Message-Id: <1356030701-16284-27-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/um/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/um/fault.c b/arch/x86/um/fault.c
index 8784ab3..84ac7f7 100644
--- a/arch/x86/um/fault.c
+++ b/arch/x86/um/fault.c
@@ -20,7 +20,7 @@ int arch_fixup(unsigned long address, struct uml_pt_regs *regs)
 	const struct exception_table_entry *fixup;
 
 	fixup = search_exception_tables(address);
-	if (fixup != 0) {
+	if (fixup) {
 		UPT_IP(regs) = fixup->fixup;
 		return 1;
 	}
-- 
1.8.0

