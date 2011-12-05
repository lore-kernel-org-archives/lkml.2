Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab1LERkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:40:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab1LERkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:40:41 -0500
Date: Mon, 5 Dec 2011 09:40:30 -0800
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-ce37defc0f6673f5ca2c92ed5cfcaf290ae7dd16@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <4ED5B70F.606@lwfinger.net>
References: <4ED5B70F.606@lwfinger.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Document rdmsr_safe restrictions
Git-Commit-ID: ce37defc0f6673f5ca2c92ed5cfcaf290ae7dd16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:40:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce37defc0f6673f5ca2c92ed5cfcaf290ae7dd16
Gitweb:     http://git.kernel.org/tip/ce37defc0f6673f5ca2c92ed5cfcaf290ae7dd16
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 5 Dec 2011 14:28:37 +0100
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Mon, 5 Dec 2011 14:28:37 +0100

x86: Document rdmsr_safe restrictions

Recently, I got bitten by using rdmsr_safe too early in the boot
process. Document its shortcomings for future reference.

Link: http://lkml.kernel.org/r/4ED5B70F.606@lwfinger.net
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 084ef95..95203d4 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -169,7 +169,14 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 	return native_write_msr_safe(msr, low, high);
 }
 
-/* rdmsr with exception handling */
+/*
+ * rdmsr with exception handling.
+ *
+ * Please note that the exception handling works only after we've
+ * switched to the "smart" #GP handler in trap_init() which knows about
+ * exception tables - using this macro earlier than that causes machine
+ * hangs on boxes which do not implement the @msr in the first argument.
+ */
 #define rdmsr_safe(msr, p1, p2)					\
 ({								\
 	int __err;						\
