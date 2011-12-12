Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1LLRut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:50:49 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:4016 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab1LLRun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:50:43 -0500
Subject: [PATCH 2/2] SYSCTL: export root register and unregister routines
To: mingo@elte.hu
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: a.p.zijlstra@chello.nl, xemul@parallels.com, drosenberg@vsecurity.com,
        linux-kernel@vger.kernel.org, eparis@redhat.com, bfields@fieldses.org,
        jbottomley@parallels.com, akpm@linux-foundation.org, devel@openvz.org
Date: Mon, 12 Dec 2011 21:50:08 +0300
Message-ID: <20111212175008.7084.69361.stgit@localhost6.localdomain6>
In-Reply-To: <20111212174709.7084.54702.stgit@localhost6.localdomain6>
References: <20111212174709.7084.54702.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These routines will be used in SUNPRC module and thus have to be exported.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 kernel/sysctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 21e68c1..0ee5b73 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1700,6 +1700,7 @@ void register_sysctl_root(struct ctl_table_root *root)
 	list_add_tail(&root->root_list, &sysctl_table_root.root_list);
 	spin_unlock(&sysctl_lock);
 }
+EXPORT_SYMBOL_GPL(register_sysctl_root);
 
 void unregister_sysctl_root(struct ctl_table_root *root)
 {
@@ -1707,6 +1708,7 @@ void unregister_sysctl_root(struct ctl_table_root *root)
 	list_del(&root->root_list);
 	spin_unlock(&sysctl_lock);
 }
+EXPORT_SYMBOL_GPL(unregister_sysctl_root);
 
 /*
  * sysctl_perm does NOT grant the superuser all rights automatically, because

