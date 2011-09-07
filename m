Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1IGE0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 00:26:39 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22408 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab1IGE0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 00:26:03 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, containers@lists.osdl.org, netdev@vger.kernel.org,
        xemul@parallels.com, Glauber Costa <glommer@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2 9/9] Add documentation about kmem_cgroup
Date: Wed,  7 Sep 2011 01:23:19 -0300
Message-Id: <1315369399-3073-10-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315369399-3073-1-git-send-email-glommer@parallels.com>
References: <1315369399-3073-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: David S. Miller <davem@davemloft.net>
CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
CC: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/cgroups/kmem_cgroups.txt |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/cgroups/kmem_cgroups.txt

diff --git a/Documentation/cgroups/kmem_cgroups.txt b/Documentation/cgroups/kmem_cgroups.txt
new file mode 100644
index 0000000..930e069
--- /dev/null
+++ b/Documentation/cgroups/kmem_cgroups.txt
@@ -0,0 +1,27 @@
+Kernel Memory Cgroup
+====================
+
+This document briefly describes the kernel memory cgroup, or "kmem cgroup".
+Unlike user memory, kernel memory cannot be swapped. This effectively means
+that rogue processes can start operations that pin kernel objects permanently
+into memory, exhausting resources of all other processes in the system.
+
+kmem_cgroup main goal is to control the amount of memory a group of processes
+can pin at any given point in time. Other uses of this infrastructure are
+expected to come up with time. Right now, the only resource effectively limited
+are tcp send and receive buffers.
+
+TCP network buffers
+===================
+
+TCP network buffers, both on the send and receive sides, can be controlled
+by the kmem cgroup. Once a socket is created, it is attached to the cgroup of
+the controller process, where it stays until the end of its lifetime.
+
+Files
+=====
+	kmem.tcp_maxmem: control the maximum amount in bytes that can be used by
+	tcp sockets inside the cgroup. 
+
+	kmem.tcp_current_memory: current amount in bytes used by all sockets in
+	this cgroup
-- 
1.7.6

