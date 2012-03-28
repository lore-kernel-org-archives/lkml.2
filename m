Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2C1QrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:47:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2C1QrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:47:09 -0400
Date: Wed, 28 Mar 2012 09:46:48 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-8f0750f19789cf352d7e24a6cc50f2ab1b4f1372@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, stable@vger.kernel.org, dan.carpenter@oracle.com
In-Reply-To: <20120324075250.GA28258@elgon.mountain>
References: <20120324075250.GA28258@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, tls: Off by one limit check
Git-Commit-ID: 8f0750f19789cf352d7e24a6cc50f2ab1b4f1372
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 28 Mar 2012 09:46:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f0750f19789cf352d7e24a6cc50f2ab1b4f1372
Gitweb:     http://git.kernel.org/tip/8f0750f19789cf352d7e24a6cc50f2ab1b4f1372
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Sat, 24 Mar 2012 10:52:50 +0300
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 28 Mar 2012 09:39:35 -0700

x86, tls: Off by one limit check

These are used as offsets into an array of GDT_ENTRY_TLS_ENTRIES members
so GDT_ENTRY_TLS_ENTRIES is one past the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://lkml.kernel.org/r/20120324075250.GA28258@elgon.mountain
Cc: <stable@vger.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/tls.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b85..bcfec2d 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -163,7 +163,7 @@ int regset_tls_get(struct task_struct *target, const struct user_regset *regset,
 {
 	const struct desc_struct *tls;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;
@@ -198,7 +198,7 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;
