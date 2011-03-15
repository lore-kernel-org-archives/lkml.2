Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1COXM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:12:27 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:52684 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754704Ab1COXMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:12:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JIrQsxxoyhIZCdukBFxbUnY1jkM4qLWNcMDaBndywXkDWvSTriTXNiL3hTDZ4ppfheKC8PA/sqdHeI/TnclzXIKljJhArQifDcet20YKelNQ4ZjkVeZaCSSVf1832oAy;
Date: Tue, 15 Mar 2011 16:12:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>, Paul Menage <menage@google.com>
Subject: [PATCH 5/6] Documentation: update cgroup pid and cpuset information
Message-Id: <20110315161218.817cd662.rdunlap@xenotime.net>
In-Reply-To: <20110315134316.465b6e2c.rdunlap@xenotime.net>
References: <20110315134316.465b6e2c.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric B Munson <emunson@mgebm.net>

The cgroup documentation does not specify how a process can be removed from a
particular group.  This patch adds a note at the end of the simple example
about how this is done.  Also, some cgroups (like cpusets) require user input
before a new group can be used.  This is noted in the patch as well.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
Changes from V1:
 Rework the note about removing a process from a cgroup
 Add note about ns cgroup causing failure when moving processes between groups

 Documentation/cgroups/cgroups.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- lnx-2638-rc8.orig/Documentation/cgroups/cgroups.txt
+++ lnx-2638-rc8/Documentation/cgroups/cgroups.txt
@@ -349,6 +349,10 @@ To mount a cgroup hierarchy with all ava
 The "xxx" is not interpreted by the cgroup code, but will appear in
 /proc/mounts so may be any useful identifying string that you like.
 
+Note: Some subsystems do not work without some user input first.  For instance,
+if cpusets are enabled the user will have to populate the cpus and mems files
+for each new cgroup created before that group can be used.
+
 To mount a cgroup hierarchy with just the cpuset and memory
 subsystems, type:
 # mount -t cgroup -o cpuset,memory hier1 /dev/cgroup
@@ -426,6 +430,14 @@ You can attach the current shell task by
 
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
 
