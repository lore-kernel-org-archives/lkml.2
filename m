Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2K0Ucs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:32:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab2K0Ucq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:32:46 -0500
Message-Id: <20121127193501.728193744@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 27 Nov 2012 14:35:02 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: [PATCH 1/5] device_cgroup: fix locking in devcgroup_destroy()
References: <20121127193501.255267751@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=devcg-devcgroup_destroy_locking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 security/device_cgroup.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: github/security/device_cgroup.c
===================================================================
--- github.orig/security/device_cgroup.c	2012-11-26 17:13:54.008153189 -0500
+++ github/security/device_cgroup.c	2012-11-27 11:58:43.574251075 -0500
@@ -215,7 +215,11 @@
 	struct dev_cgroup *dev_cgroup;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
+
+	mutex_lock(&devcgroup_mutex);
 	dev_exception_clean(dev_cgroup);
+	mutex_unlock(&devcgroup_mutex);
+
 	kfree(dev_cgroup);
 }
 

