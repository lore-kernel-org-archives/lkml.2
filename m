Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2JXM5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:57:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56638 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab2JXM5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:57:04 -0400
Date: Wed, 24 Oct 2012 05:55:26 -0700
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Message-ID: <tip-99fb4a122e96203dfd6c67d99d908aafd20f4753@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20121020190519.GH25467@moon>
References: <20121020190519.GH25467@moon>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Use KSYM_NAME_LEN'
 ed buffer for __get_key_name()
Git-Commit-ID: 99fb4a122e96203dfd6c67d99d908aafd20f4753
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 05:55:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99fb4a122e96203dfd6c67d99d908aafd20f4753
Gitweb:     http://git.kernel.org/tip/99fb4a122e96203dfd6c67d99d908aafd20f4753
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 20 Oct 2012 23:05:19 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 12:39:09 +0200

lockdep: Use KSYM_NAME_LEN'ed buffer for __get_key_name()

Not a big deal, but since other __get_key_name() callers
use it lets be consistent.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20121020190519.GH25467@moon
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lockdep_proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 91c32a0..b2c71c5 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -39,7 +39,7 @@ static void l_stop(struct seq_file *m, void *v)
 
 static void print_name(struct seq_file *m, struct lock_class *class)
 {
-	char str[128];
+	char str[KSYM_NAME_LEN];
 	const char *name = class->name;
 
 	if (!name) {
