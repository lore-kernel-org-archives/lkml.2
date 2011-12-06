Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab1LFGX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:23:27 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58894 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab1LFGXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:23:25 -0500
From: Weiping Pan <panweiping3@gmail.com>
Cc: Weiping Pan <panweiping3@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net> (maintainer:DOCUMENTATION),
        "David S. Miller" <davem@davemloft.net> (commit_signer:11/16=69%),
        Eric Dumazet <eric.dumazet@gmail.com> (commit_signer:3/16=19%),
        Shan Wei <shanwei@cn.fujitsu.com> (commit_signer:3/16=19%),
        Neil Horman <nhorman@tuxdriver.com> (commit_signer:2/16=12%),
        Max Matveev <makc@redhat.com> (commit_signer:2/16=12%),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net]ipv4:correct description for tcp_max_syn_backlog
Date: Tue,  6 Dec 2011 14:26:09 +0800
Message-Id: <cbb1399605b0c1fb69da3da08373c7a1874ec206.1323152726.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit c5ed63d66f24(tcp: fix three tcp sysctls tuning),
sysctl_max_syn_backlog is determined by tcp_hashinfo->ehash_mask,
and the minimal value is 128, and it will increase in proportion to the
memory of machine.
The original description for tcp_max_syn_backlog has grammar error,
and it is out of date.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 Documentation/networking/ip-sysctl.txt |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

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
-- 
1.7.4.4

