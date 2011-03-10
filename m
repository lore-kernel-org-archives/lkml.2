Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1CJRHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:07:55 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42827 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1CJRHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:07:51 -0500
From: Eric B Munson <emunson@mgebm.net>
To: linux-doc@vger.kernel.org
Cc: containers@lists.linux-foundation.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, kirill@shutemov.name, menage@google.com,
        mike@librato.com, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH V2] Documentation: cgroups: Add notes on removing PIDs from tasks and cgroups requiring setup
Date: Thu, 10 Mar 2011 12:07:42 -0500
Message-Id: <1299776862-6931-1-git-send-email-emunson@mgebm.net>
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
Changes from V1:
 Rework the note about removing a process from a cgroup
 Add note about ns cgroup causing failure when moving processes between groups

 Documentation/cgroups/cgroups.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 44b8b7a..cbdfb7d 100644
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
@@ -426,6 +430,14 @@ You can attach the current shell task by echoing 0:
 
 # echo 0 > tasks
 
+Note: Since every task is always a member of exactly one cgroup in each
+mounted hierarchy, to remove a task from its current cgroup you must
+move it into a new cgroup (possibly the root cgroup) by writing to the
+new cgroup's tasks file.
+
+Note: If the ns cgroup is active, moving a process to another cgroup can
+fail.
+
 2.3 Mounting hierarchies by name
 --------------------------------
 
-- 
1.7.1

