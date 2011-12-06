Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab1LFHhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:37:09 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55619 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab1LFHhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:37:07 -0500
From: Weiping Pan <panweiping3@gmail.com>
To: shanwei88@gmail.com
Cc: Weiping Pan <panweiping3@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net> (maintainer:DOCUMENTATION),
        "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING
	[GENERAL],commit_signer:11/16=69%),
        Eric Dumazet <eric.dumazet@gmail.com> (commit_signer:3/16=19%),
        Shan Wei <shanwei@cn.fujitsu.com> (commit_signer:3/16=19%),
        Neil Horman <nhorman@tuxdriver.com> (commit_signer:2/16=12%),
        Max Matveev <makc@redhat.com> (commit_signer:2/16=12%),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH V2 net] ipv4:correct description for tcp_max_syn_backlog
Date: Tue,  6 Dec 2011 15:39:41 +0800
Message-Id: <ed04712f4f61e291ac784a8a77e2831981cfb9c1.1323156956.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <4EDDC1D6.6000708@gmail.com>
References: <4EDDC1D6.6000708@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit c5ed63d66f24(tcp: fix three tcp sysctls tuning),
sysctl_max_syn_backlog is determined by tcp_hashinfo->ehash_mask,
and the minimal value is 128, and it will increase in proportion to the
memory of machine.
The original description for tcp_max_syn_backlog and sysctl_max_syn_backlog
are out of date.

Changelog:
V2: update description for sysctl_max_syn_backlog

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 Documentation/networking/ip-sysctl.txt |   10 +++++-----
 net/core/request_sock.c                |    7 ++++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index f049a1c..589f2da 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -282,11 +282,11 @@ tcp_max_ssthresh - INTEGER
 	Default: 0 (off)
 
 tcp_max_syn_backlog - INTEGER
-	Maximal number of remembered connection requests, which are
-	still did not receive an acknowledgment from connecting client.
-	Default value is 1024 for systems with more than 128Mb of memory,
-	and 128 for low memory machines. If server suffers of overload,
-	try to increase this number.
+	Maximal number of remembered connection requests, which have not
+	received an acknowledgment from connecting client.
+	The minimal value is 128 for low memory machines, and it will
+	increase in proportion to the memory of machine.
+	If server suffers from overload, try increasing this number.
 
 tcp_max_tw_buckets - INTEGER
 	Maximal number of timewait sockets held by system simultaneously.
diff --git a/net/core/request_sock.c b/net/core/request_sock.c
index 182236b..9b570a6 100644
--- a/net/core/request_sock.c
+++ b/net/core/request_sock.c
@@ -26,10 +26,11 @@
  * but then some measure against one socket starving all other sockets
  * would be needed.
  *
- * It was 128 by default. Experiments with real servers show, that
+ * The minimum value of it is 128. Experiments with real servers show that
  * it is absolutely not enough even at 100conn/sec. 256 cures most
- * of problems. This value is adjusted to 128 for very small machines
- * (<=32Mb of memory) and to 1024 on normal or better ones (>=256Mb).
+ * of problems.
+ * This value is adjusted to 128 for low memory machines,
+ * and it will increase in proportion to the memory of machine.
  * Note : Dont forget somaxconn that may limit backlog too.
  */
 int sysctl_max_syn_backlog = 256;
-- 
1.7.4.4

