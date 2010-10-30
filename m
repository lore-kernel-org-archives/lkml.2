Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0J3KlW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 06:41:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:48417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab0J3KlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 06:41:20 -0400
Date: Sat, 30 Oct 2010 10:40:59 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        davem@davemloft.net, rostedt@goodmis.org, srostedt@redhat.com,
        ddaney@caviumnetworks.com, tglx@linutronix.de, jbaron@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, rostedt@goodmis.org, srostedt@redhat.com,
        ddaney@caviumnetworks.com, tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <20101015201037.703989993@goodmis.org>
References: <1286218615-24011-2-git-send-email-ddaney@caviumnetworks.com>
	<20101015201037.703989993@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] jump label: Make arch_jump_label_text_poke_early() optional
Message-ID: <tip-95bcd683fb694a3e2d0538bf486430a0dfbb4111@git.kernel.org>
Git-Commit-ID: 95bcd683fb694a3e2d0538bf486430a0dfbb4111
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 10:41:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95bcd683fb694a3e2d0538bf486430a0dfbb4111
Gitweb:     http://git.kernel.org/tip/95bcd683fb694a3e2d0538bf486430a0dfbb4111
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 29 Oct 2010 11:02:43 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 29 Oct 2010 12:56:13 -0400

jump label: Make arch_jump_label_text_poke_early() optional

Some archs do not need to do anything special for jump labels on
startup (like MIPS).  This patch adds a weak function stub for
arch_jump_label_text_poke_early();

Cc: Jason Baron <jbaron@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: David Daney <ddaney@caviumnetworks.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1286218615-24011-2-git-send-email-ddaney@caviumnetworks.com>
LKML-Reference: <20101015201037.703989993@goodmis.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/jump_label.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 12cce78..3b79bd9 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -270,6 +270,13 @@ out:
 	return conflict;
 }
 
+/*
+ * Not all archs need this.
+ */
+void __weak arch_jump_label_text_poke_early(jump_label_t addr)
+{
+}
+
 static __init int init_jump_label(void)
 {
 	int ret;
