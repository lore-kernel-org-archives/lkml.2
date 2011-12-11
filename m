Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1LKOuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 09:50:55 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36850 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab1LKOup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 09:50:45 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: jbottomley@parallels.com, cgroups@vger.kernel.org, bsingharora@gmail.com,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 1/3] nitpick: make simple functions inline
Date: Sun, 11 Dec 2011 15:45:36 +0100
Message-Id: <1323614738-7405-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323614738-7405-1-git-send-email-glommer@parallels.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those are quite simple bit-testing functions that are
only used within this file. Not reason for them not to
be inline.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d9d5648..e4b9d3c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -241,12 +241,12 @@ static int cgroup_is_releasable(const struct cgroup *cgrp)
 	return (cgrp->flags & bits) == bits;
 }
 
-static int notify_on_release(const struct cgroup *cgrp)
+static inline int notify_on_release(const struct cgroup *cgrp)
 {
 	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 }
 
-static int clone_children(const struct cgroup *cgrp)
+static inline int clone_children(const struct cgroup *cgrp)
 {
 	return test_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
 }
-- 
1.7.6.4

