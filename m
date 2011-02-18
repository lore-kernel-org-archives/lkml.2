Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab1BRKk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:40:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:50706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab1BRKkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:40:23 -0500
Date: Fri, 18 Feb 2011 10:40:01 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D5D535A0200007800032730@vpn.id2.novell.com>
References: <4D5D535A0200007800032730@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Combine printk()s in show_regs_common()
Message-ID: <tip-fd8fa4d3ddc4cc04ec8097e632b995d535c52beb@git.kernel.org>
Git-Commit-ID: fd8fa4d3ddc4cc04ec8097e632b995d535c52beb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 10:40:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd8fa4d3ddc4cc04ec8097e632b995d535c52beb
Gitweb:     http://git.kernel.org/tip/fd8fa4d3ddc4cc04ec8097e632b995d535c52beb
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 17 Feb 2011 15:56:58 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Feb 2011 08:52:30 +0100

x86: Combine printk()s in show_regs_common()

Printing a single character alone when there's an immediately
following printk() is pretty pointless (and wasteful).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4D5D535A0200007800032730@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ff45541..99fa3ad 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -110,12 +110,9 @@ void show_regs_common(void)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	printk(KERN_CONT " ");
-	printk(KERN_CONT "%s %s", vendor, product);
-	if (board) {
-		printk(KERN_CONT "/");
-		printk(KERN_CONT "%s", board);
-	}
+	printk(KERN_CONT " %s %s", vendor, product);
+	if (board)
+		printk(KERN_CONT "/%s", board);
 	printk(KERN_CONT "\n");
 }
 
