Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1IWGVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:21:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1IWGVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:21:17 -0400
Subject: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from a
 cpuset
From: Mike Galbraith <mgalbraith@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Menage <paul@paulmenage.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 08:21:14 +0200
Message-ID: <1316758874.7393.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kworkers can be born in a cpuset, leaving them adrift on an unsinkable ship.
Allow them to be moved to the root cpuset so the cpuset can be destroyed.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 10131fd..b26f4c4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1384,7 +1384,7 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
 	 * be changed.
 	 */
-	if (tsk->flags & PF_THREAD_BOUND)
+	if (tsk->flags & PF_THREAD_BOUND && cont->parent)
 		return -EINVAL;
 
 	return 0;


