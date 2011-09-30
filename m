Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab1I3MC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:02:26 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:60964 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758457Ab1I3MCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:02:25 -0400
X-Greylist: delayed 1516 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Sep 2011 08:02:25 EDT
From: Witold Krecicki <wpk@culm.net>
To: Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Witold Krecicki <wpk@culm.net>
Subject: [PATCH 6/6] cgroup: documentation of isolation_root cgroup flag
Date: Fri, 30 Sep 2011 13:36:25 +0200
Message-Id: <1317382585-12172-7-git-send-email-wpk@culm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317382585-12172-1-git-send-email-wpk@culm.net>
References: <1317382585-12172-1-git-send-email-wpk@culm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation of isolation_root cgroup flag.

Signed-off-by: Witold Krecicki <wpk@culm.net>
---
 Documentation/cgroups/cgroups.txt |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index cd67e90..66880a6 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -19,7 +19,8 @@ CONTENTS:
   1.3 How are cgroups implemented ?
   1.4 What does notify_on_release do ?
   1.5 What does clone_children do ?
-  1.6 How do I use cgroups ?
+  1.6 What does isolation_root do ?
+  1.7 How do I use cgroups ?
 2. Usage Examples and Syntax
   2.1 Basic Usage
   2.2 Attaching processes
@@ -304,7 +305,22 @@ subsystem of the newly created cgroup. Usually when this callback is
 implemented for a subsystem, it copies the values of the parent
 subsystem, this is the case for the cpuset.
 
-1.6 How do I use cgroups ?
+1.6 What does isolation_root do ?
+---------------------------------
+
+If the isolation_root flag is enabled (1) in a cgroup, then all tasks
+in this cgroup and its children will see this group as its top group
+in /proc/$PID/cgroup. Also mounts of cgroup filesystem performed by a task
+in isolation root cgroup will see isolation root cgroup as top cgroup.
+It is impossible for a task to exit isolated root. Flag may only be set or
+cleared when the cgroup is not in use.
+The preffered way to use isolation_root for containers (eg. lxc) is to
+create 'master' cgroup - /sys/fs/cgroup/cpu/container_name with settings
+for the container, then create /sys/fs/cgroup/cpu/container_name/root with
+isolation_root flag set and add the 'init' task for the container to
+this cgroup.
+
+1.7 How do I use cgroups ?
 --------------------------
 
 To start a new job that is to be contained within a cgroup, using
-- 
1.7.4.1

