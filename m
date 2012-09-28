Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166Ab2I1Xl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:41:29 -0400
Received: from nm16-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.253]:32770 "HELO
	nm16-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965103Ab2I1XlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:41:25 -0400
X-Yahoo-Newman-Id: 322336.10138.bm@smtp115.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MwW2Tr0VM1lvSBIfXNHTXG4a6TCR5_dfcS_T1B6i.ai7iTA
 cQ9fjhKf.8KjJaquW_BwHzWJC9PgMRTe7T.NPPc8tpMb6Yt9dUUEIG9Qbq4l
 cJXwzcAB3Q4N29HknwtHTU74.tSQDSs2qNhoVFIrXbWaojmWd_VydBvQcbvl
 vgQ0lz_kLXE2zy6VcjN6b3Y94caLbWJIYgqV2C39eDdo2vFosx5_ks_gH43D
 CHJ8NMpJqVGyaSvv04_DBf8sc64JZll6cZD6ioCdnHFsLUIf7j7hFMqFvRiK
 AnTJMIEcGiJcQM4sUrzfjjc26ppeWw49.WIjQL7YbsexQ7QTszGnZ9MMbFFh
 BQgV4GlPhf_3QaTBSoHPbE9KvB_KEKwNe5N0khnuH6sXREtb2kjCpo28yRCR
 6dV4Jv5OV_zKU6fwTj9XzQ1qzjdQVx4BTgpWBRMoys3nGSoRGcmy3
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-doc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v6 5/10] rbtree.h: add doc comments for struct rb_node
Date: Fri, 28 Sep 2012 18:40:20 -0500
Message-Id: <1348875625-28669-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
References: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/rbtree.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 5f10915..c815b5e 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -35,6 +35,20 @@
 #include <linux/bug.h>
 #include <linux/kconfig.h>
 
+/**
+ * struct rb_node
+ * @__rb_parent_color: Contains the color in the lower 2 bits (although only
+ * 		       bit zero is currently used) and the address of the
+ * 		       parent in the rest (lower 2 bits of address should
+ * 		       always be zero on any arch supported).  If the node is
+ * 		       initialized and not a member of any tree, the parent
+ * 		       point to its self.  If the node belongs to a tree, but
+ * 		       is the root element, the parent will be NULL.
+ * 		       Otherwise, parent will always point to the parent node
+ * 		       in the tree.
+ * @rb_right:          Pointer to the right element.
+ * @rb_left:           Pointer to the left element.
+ */
 struct rb_node {
 	unsigned long  __rb_parent_color;
 	struct rb_node *rb_right;
-- 
1.7.3.4

