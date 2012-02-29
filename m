Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030909Ab2B2KPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:15:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58625 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030332Ab2B2KPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:15:11 -0500
Date: Wed, 29 Feb 2012 02:14:27 -0800
From: tip-bot for Jason Baron <jbaron@redhat.com>
Message-ID: <tip-a746e3cc984b0aa5b620dd07c1a433283b1835cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
In-Reply-To: <08026cbc6df80619cae833ef1ebbbc43efab69ab.1329851692.git.jbaron@redhat.com>
References: <08026cbc6df80619cae833ef1ebbbc43efab69ab.1329851692.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Fix compiler warning
Git-Commit-ID: a746e3cc984b0aa5b620dd07c1a433283b1835cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 29 Feb 2012 02:14:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a746e3cc984b0aa5b620dd07c1a433283b1835cf
Gitweb:     http://git.kernel.org/tip/a746e3cc984b0aa5b620dd07c1a433283b1835cf
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Tue, 21 Feb 2012 15:02:57 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 07:59:40 +0100

jump label: Fix compiler warning

While cross-compiling on sparc64, I found:

kernel/jump_label.c: In function 'jump_label_update':
kernel/jump_label.c:447:40: warning: cast from pointer to
integer of different size [-Wpointer-to-int-cast]

Fix by casting to 'unsigned long'.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: davem@davemloft.net
Cc: ddaney.cavm@gmail.com
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/08026cbc6df80619cae833ef1ebbbc43efab69ab.1329851692.git.jbaron@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/jump_label.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index ed9654f..543782e 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -424,7 +424,7 @@ static void jump_label_update(struct jump_label_key *key, int enable)
 	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
 
 #ifdef CONFIG_MODULES
-	struct module *mod = __module_address((jump_label_t)key);
+	struct module *mod = __module_address((unsigned long)key);
 
 	__jump_label_mod_update(key, enable);
 
