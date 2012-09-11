Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2IKU2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 16:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab2IKU2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 16:28:20 -0400
Message-Id: <20120911202810.406133423@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 11 Sep 2012 16:28:10 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH v2 1/2] cgroups: add documentation on extended attributes usage
References: <20120911202809.988739953@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=doc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: update cgroups.txt instead of creating a new file

Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lennart Poettering <lpoetter@redhat.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 Documentation/cgroups/cgroups.txt |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

Index: github/Documentation/cgroups/cgroups.txt
===================================================================
--- github.orig/Documentation/cgroups/cgroups.txt	2012-08-16 10:24:48.437596817 -0400
+++ github/Documentation/cgroups/cgroups.txt	2012-09-07 10:23:19.974357952 -0400
@@ -29,7 +29,8 @@
   3.1 Overview
   3.2 Synchronization
   3.3 Subsystem API
-4. Questions
+4. Extended attributes usage
+5. Questions
 
 1. Control Groups
 =================
@@ -650,7 +651,26 @@
 the default hierarchy (which never has sub-cgroups) and a hierarchy
 that is being created/destroyed (and hence has no sub-cgroups).
 
-4. Questions
+4. Extended attribute usage
+===========================
+
+cgroup filesystem supports certain types of extended attributes in its
+directories and files.  The current supported types are:
+	- Trusted (XATTR_TRUSTED)
+	- Security (XATTR_SECURITY)
+
+Both require CAP_SYS_ADMIN capability to set.
+
+Like in tmpfs, the extended attributes in cgroup filesystem are stored
+using kernel memory and it's advised to keep the usage at minimum.  This
+is the reason why user defined extended attributes are not supported, since
+any user can do it and there's no limit in the value size.
+
+The current known users for this feature are SELinux to limit cgroup usage
+in containers and systemd for assorted meta data like main PID in a cgroup
+(systemd creates a cgroup per service).
+
+5. Questions
 ============
 
 Q: what's up with this '/bin/echo' ?

