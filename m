Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab0EFRiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:38:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759347Ab0EFRh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:37:59 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/13] kernel/fs/security: removing redundant ifdefs
Date: Thu,  6 May 2010 19:36:05 +0200
Message-Id: <1273167377-14270-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 fs/ext4/super.c                |    2 --
 include/linux/socket.h         |    4 ----
 kernel/sched.c                 |    6 ------
 kernel/srcu.c                  |    2 --
 security/capability.c          |    2 --
 sound/pci/au88x0/au88x0_core.c |    4 ----
 6 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14d22c..afba6f0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1067,9 +1067,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
 
 static const struct dquot_operations ext4_quota_operations = {
-#ifdef CONFIG_QUOTA
 	.get_reserved_space = ext4_get_reserved_space,
-#endif
 	.write_dquot	= ext4_write_dquot,
 	.acquire_dquot	= ext4_acquire_dquot,
 	.release_dquot	= ext4_release_dquot,
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 354cc56..9fda7c4 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -27,12 +27,10 @@ struct __kernel_sockaddr_storage {
 #define __sockaddr_check_size(size)	\
 	BUILD_BUG_ON(((size) > sizeof(struct __kernel_sockaddr_storage)))
 
-#ifdef __KERNEL__
 # ifdef CONFIG_PROC_FS
 struct seq_file;
 extern void socket_seq_show(struct seq_file *seq);
 # endif
-#endif /* __KERNEL__ */
 
 typedef unsigned short	sa_family_t;
 
@@ -305,7 +303,6 @@ struct ucred {
 /* IPX options */
 #define IPX_TYPE	1
 
-#ifdef __KERNEL__
 extern int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
 extern int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
 			       int offset, int len);
@@ -326,6 +323,5 @@ struct timespec;
 
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 			  unsigned int flags, struct timespec *timeout);
-#endif
 #endif /* not kernel and not glibc */
 #endif /* _LINUX_SOCKET_H */
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a0f37c..fcbe30e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -311,12 +311,8 @@ static inline struct task_group *task_group(struct task_struct *p)
 {
 	struct task_group *tg;
 
-#ifdef CONFIG_CGROUP_SCHED
 	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
 				struct task_group, css);
-#else
-	tg = &init_task_group;
-#endif
 	return tg;
 }
 
@@ -471,9 +467,7 @@ struct root_domain {
 	 */
 	cpumask_var_t rto_mask;
 	atomic_t rto_count;
-#ifdef CONFIG_SMP
 	struct cpupri cpupri;
-#endif
 };
 
 /*
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 2980da3..c71e075 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -46,11 +46,9 @@ static int init_srcu_struct_fields(struct srcu_struct *sp)
 int __init_srcu_struct(struct srcu_struct *sp, const char *name,
 		       struct lock_class_key *key)
 {
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/* Don't re-initialize a lock while it is held. */
 	debug_check_no_locks_freed((void *)sp, sizeof(*sp));
 	lockdep_init_map(&sp->dep_map, name, key, 0);
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 	return init_srcu_struct_fields(sp);
 }
 EXPORT_SYMBOL_GPL(__init_srcu_struct);
diff --git a/security/capability.c b/security/capability.c
index 5a0dd31..750f336 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -698,9 +698,7 @@ static int cap_socket_getpeersec_dgram(struct socket *sock,
 
 static int cap_sk_alloc_security(struct sock *sk, int family, gfp_t priority)
 {
-#ifdef CONFIG_SECURITY_NETWORK
 	sk->sk_security = NULL;
-#endif
 	return 0;
 }
 
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 23f49f3..f82f2a1 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -941,10 +941,8 @@ vortex_fifo_setwtctrl(vortex_t * vortex, int fifo, int ctrl, int priority,
 			temp = (temp & 0xf7ffffff) | ((f & 1) << 0x1b);
 			temp = (temp & 0xefffffff) | ((f & 1) << 0x1c);
 #endif
-#ifdef CHIP_AU8810
 			temp = (temp & 0xfeffffff) | ((f & 1) << 0x18);
 			temp = (temp & 0xfdffffff) | ((f & 1) << 0x19);
-#endif
 		}
 	} else {
 		if (temp & FIFO_VALID) {
@@ -955,10 +953,8 @@ vortex_fifo_setwtctrl(vortex_t * vortex, int fifo, int ctrl, int priority,
 			temp =
 			    ((f & 1) << 0x1b) | (temp & 0xe7ffffef) | FIFO_BITS;
 #endif
-#ifdef CHIP_AU8810
 			temp =
 			    ((f & 1) << 0x18) | (temp & 0xfcffffef) | FIFO_BITS;
-#endif
 		} else
 			/*if (this_8[fifo]) */
 			vortex_fifo_clearwtdata(vortex, fifo, FIFO_SIZE);
-- 
1.6.6.1

