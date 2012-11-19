Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2KSFb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:26 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50100 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KSFbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:23 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 36/58] kernel/fork.c: Add prototype for __weak stub of arch_release_thread_info
Date: Sun, 18 Nov 2012 21:28:15 -0800
Message-Id: <1353302917-13995-37-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/fork.c defines an empty stub of arch_release_thread_info with
__weak, for use on architectures without an alternate implementation.
Define a prototype of that function, to satisfy gcc
(-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/fork.c:137:28: warning: no previous prototype for ‘arch_release_thread_info’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/fork.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8b20ab7..8532f1a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -132,6 +132,8 @@ static inline void free_task_struct(struct task_struct *tsk)
 }
 #endif
 
+void arch_release_thread_info(struct thread_info *ti);
+
 void __weak arch_release_thread_info(struct thread_info *ti)
 {
 }
-- 
1.7.10.4

