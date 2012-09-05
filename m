Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab2IEScw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:32:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab2IESbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:31:41 -0400
Message-Id: <20120905183133.162440150@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Wed, 05 Sep 2012 14:31:33 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: [PATCH 1/2] cgroups: add documentation on extended attributes usage
References: <20120905183132.806473183@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=doc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lennart Poettering <lpoetter@redhat.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 Documentation/cgroups/00-INDEX  |    2 ++
 Documentation/cgroups/xattr.txt |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/Documentation/cgroups/00-INDEX	2010-07-29 22:53:28.000000000 -0400
+++ b/Documentation/cgroups/00-INDEX	2012-08-30 12:32:18.419879863 -0400
@@ -16,3 +16,5 @@ memory.txt
 	- Memory Resource Controller; design, accounting, interface, testing.
 resource_counter.txt
 	- Resource Counter API.
+xattr.txt
+	- Extended attributes support and usage in cgroup filesystem
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/Documentation/cgroups/xattr.txt	2012-08-30 13:02:56.585865106 -0400
@@ -0,0 +1,21 @@
+Extended Attributes Usage in cgroup Filesystem
+
+1. Usage
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
+2. Users
+
+The current known users for this feature are SELinux to limit cgroup usage
+in containers and systemd for assorted meta data like main PID in a cgroup
+(systemd creates a cgroup per service).

