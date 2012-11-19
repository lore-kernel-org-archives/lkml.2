Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab2KSFbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:32 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48648 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KSFb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:28 -0500
X-Originating-IP: 217.70.178.133
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 37/58] kernel/fork.c: Add prototype for fork_init
Date: Sun, 18 Nov 2012 21:28:16 -0800
Message-Id: <1353302917-13995-38-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/fork.c defines an __init function fork_init, called from
init/main.c.  No header file prototypes fork_init, because init/main.c
tends to directly define prototypes for init functions it calls, rather
than including appropriate headers.  So, add a prototype of fork_init to
kernel/fork.c right above the definition, to satisfy gcc
(-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/fork.c:251:116: warning: no previous prototype for ‘fork_init’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/fork.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8532f1a..5971176 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -250,6 +250,8 @@ EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init __weak arch_task_cache_init(void) { }
 
+void fork_init(unsigned long mempages);
+
 void __init fork_init(unsigned long mempages)
 {
 #ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
-- 
1.7.10.4

