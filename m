Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1CIVLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:11:51 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56374 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1CIVLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:11:46 -0500
From: Eric B Munson <emunson@mgebm.net>
To: containers@lists.linux-foundation.org
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH] Documentation: cgroups: Add notes on removing PIDs from tasks and cgroups requiring setup
Date: Wed,  9 Mar 2011 16:09:29 -0500
Message-Id: <1299704969-4485-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cgroup documentation does not specify how a process can be removed from a
particular group.  This patch adds a note at the end of the simple example
about how this is done.  Also, some cgroups (like cpusets) require user input
before a new group can be used.  This is noted in the patch as well.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 Documentation/cgroups/cgroups.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 44b8b7a..6c975a1 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -349,6 +349,10 @@ To mount a cgroup hierarchy with all available subsystems, type:
 The "xxx" is not interpreted by the cgroup code, but will appear in
 /proc/mounts so may be any useful identifying string that you like.
 
+Note: Some subsystems do not work without some user input first.  For instance,
+if cpusets are enabled the user will have to populate the cpus and mems files
+for each new cgroup created before that group can be used.
+
 To mount a cgroup hierarchy with just the cpuset and memory
 subsystems, type:
 # mount -t cgroup -o cpuset,memory hier1 /dev/cgroup
@@ -426,6 +430,9 @@ You can attach the current shell task by echoing 0:
 
 # echo 0 > tasks
 
+Note: To remove a task from a cgroup you must write its PID to the root
+tasks file.
+
 2.3 Mounting hierarchies by name
 --------------------------------
 
-- 
1.7.1

