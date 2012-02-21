Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2BUUDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:03:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab2BUUDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:03:15 -0500
Date: Tue, 21 Feb 2012 15:02:57 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Message-Id: <08026cbc6df80619cae833ef1ebbbc43efab69ab.1329851692.git.jbaron@redhat.com>
In-Reply-To: <cover.1329851692.git.jbaron@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
Subject: [PATCH 02/10] jump label: fix compiler warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While cross-compiling on sparc64, I found:

kernel/jump_label.c: In function 'jump_label_update':
kernel/jump_label.c:447:40: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Fix by casting to 'unsigned long'.

Signed-off-by: Jason Baron <jbaron@redhat.com>
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
 
-- 
1.7.7.5

