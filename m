Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab2JYOYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:24:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53771 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab2JYOYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:24:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] unshare: remove dead code
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Thu, 25 Oct 2012 15:25:54 +0100
Message-ID: <20121025142539.16724.76390.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

If new_nsproxy is set we will always call switch_task_namespaces and then
set new_nsproxy back to NULL so the reassignment and fall through check
are redundant

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 kernel/fork.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index acc4cb6..60854b2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1792,10 +1792,8 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 			exit_sem(current);
 		}
 
-		if (new_nsproxy) {
+		if (new_nsproxy)
 			switch_task_namespaces(current, new_nsproxy);
-			new_nsproxy = NULL;
-		}
 
 		task_lock(current);
 
@@ -1819,9 +1817,6 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 		task_unlock(current);
 	}
 
-	if (new_nsproxy)
-		put_nsproxy(new_nsproxy);
-
 bad_unshare_cleanup_fd:
 	if (new_fd)
 		put_files_struct(new_fd);

