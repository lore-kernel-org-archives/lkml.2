Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab1EMIwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:52:47 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40428 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189Ab1EMIwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:52:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Iew+AQYt/UXHHBoVTDPpb2U60ZPtX4QDABNhP2M2eGy2AAHNMSyEGewiN/g7Vri5H
	vSxBlPjM7T9xj+XcD3oKQ==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>
Subject: [RFC][PATCH v7 09/14] cgroup: move CSS_ID_MAX to cgroup.h
Date: Fri, 13 May 2011 01:47:48 -0700
Message-Id: <1305276473-14780-10-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305276473-14780-1-git-send-email-gthelen@google.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows users of css_id() to know the largest possible css_id value.
This knowledge can be used to build per-cgroup bitmaps.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ab4ac0c..5eb6543 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -624,6 +624,7 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 		     const struct cgroup_subsys_state *root);
 
 /* Get id and depth of css */
+#define CSS_ID_MAX	(65535)
 unsigned short css_id(struct cgroup_subsys_state *css);
 unsigned short css_depth(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2731d11..ab7e7a7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -129,7 +129,6 @@ static struct cgroupfs_root rootnode;
  * CSS ID -- ID per subsys's Cgroup Subsys State(CSS). used only when
  * cgroup_subsys->use_id != 0.
  */
-#define CSS_ID_MAX	(65535)
 struct css_id {
 	/*
 	 * The css to which this ID points. This pointer is set to valid value
-- 
1.7.3.1

