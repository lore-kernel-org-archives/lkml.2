Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab0GNUMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:12:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54609 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567Ab0GNUKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        Arnd Bergmann <arnd@arndb.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH RFC tip/core/rcu 07/30] nfs: __rcu annotations
Date: Wed, 14 Jul 2010 13:09:41 -0700
Message-Id: <1279138204-12849-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 include/linux/nfs_fs.h          |    2 +-
 include/linux/sunrpc/auth_gss.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 77c2ae5..a619070 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -178,7 +178,7 @@ struct nfs_inode {
 	struct nfs4_cached_acl	*nfs4_acl;
         /* NFSv4 state */
 	struct list_head	open_states;
-	struct nfs_delegation	*delegation;
+	struct nfs_delegation __rcu *delegation;
 	fmode_t			 delegation_state;
 	struct rw_semaphore	rwsem;
 #endif /* CONFIG_NFS_V4*/
diff --git a/include/linux/sunrpc/auth_gss.h b/include/linux/sunrpc/auth_gss.h
index 671538d..8eee9db 100644
--- a/include/linux/sunrpc/auth_gss.h
+++ b/include/linux/sunrpc/auth_gss.h
@@ -69,7 +69,7 @@ struct gss_cl_ctx {
 	enum rpc_gss_proc	gc_proc;
 	u32			gc_seq;
 	spinlock_t		gc_seq_lock;
-	struct gss_ctx		*gc_gss_ctx;
+	struct gss_ctx __rcu	*gc_gss_ctx;
 	struct xdr_netobj	gc_wire_ctx;
 	u32			gc_win;
 	unsigned long		gc_expiry;
@@ -80,7 +80,7 @@ struct gss_upcall_msg;
 struct gss_cred {
 	struct rpc_cred		gc_base;
 	enum rpc_gss_svc	gc_service;
-	struct gss_cl_ctx	*gc_ctx;
+	struct gss_cl_ctx __rcu	*gc_ctx;
 	struct gss_upcall_msg	*gc_upcall;
 	unsigned long		gc_upcall_timestamp;
 	unsigned char		gc_machine_cred : 1;
-- 
1.7.0.6

