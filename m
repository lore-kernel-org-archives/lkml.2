Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2LTWjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:39:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57667 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2LTWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:39:29 -0500
Date: Thu, 20 Dec 2012 14:39:09 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-7be0b06520e8219e28f54cd05e1310e7e2d921ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, richard@nod.at, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, richard@nod.at, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1356030701-16284-27-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-27-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] um: don't compare a pointer to 0
Git-Commit-ID: 7be0b06520e8219e28f54cd05e1310e7e2d921ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Dec 2012 14:39:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7be0b06520e8219e28f54cd05e1310e7e2d921ee
Gitweb:     http://git.kernel.org/tip/7be0b06520e8219e28f54cd05e1310e7e2d921ee
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 20 Dec 2012 14:11:35 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Dec 2012 11:49:39 -0800

um: don't compare a pointer to 0

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Link: http://lkml.kernel.org/r/1356030701-16284-27-git-send-email-sasha.levin@oracle.com
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
