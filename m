Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab1DYUgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:36:13 -0400
Received: from 1wt.eu ([62.212.114.60]:34526 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab1DYUZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:16 -0400
Message-Id: <20110425200239.858405164@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 158/173] CAN: Use inode instead of kernel address for /proc file
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 9f260e0efa4766e56d0ac14f1aeea6ee5eb8fe83 upstream.

Since the socket address is just being used as a unique identifier, its
inode number is an alternative that does not leak potentially sensitive
information.

CC-ing stable because MITRE has assigned CVE-2010-4565 to the issue.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/bcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/net/can/bcm.c
===================================================================
--- longterm-2.6.27.orig/net/can/bcm.c	2011-01-29 11:22:46.000000000 +0100
+++ longterm-2.6.27/net/can/bcm.c	2011-04-25 17:20:40.456278152 +0200
@@ -121,7 +121,7 @@
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
 	struct proc_dir_entry *bcm_proc_read;
-	char procname [20]; /* pointer printed in ASCII with \0 */
+	char procname [32]; /* inode number in decimal with \0 */
 };
 
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
@@ -1479,7 +1479,7 @@
 
 	if (proc_dir) {
 		/* unique socket address as filename */
-		sprintf(bo->procname, "%p", sock);
+		sprintf(bo->procname, "%lu", sock_i_ino(sk));
 		bo->bcm_proc_read = create_proc_read_entry(bo->procname, 0644,
 							   proc_dir,
 							   bcm_read_proc, sk);


