Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2IQKgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:36:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56671 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab2IQKgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:36:03 -0400
Date: Mon, 17 Sep 2012 20:35:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Peter Moody <pmoody@google.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: linux-next: manual merge of the akpm tree with the security tree
Message-Id: <20120917203545.31b6286a4ac4743bc50f0d3b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_20_35_45_+1000_oovN2CUMgi6rRu0R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_20_35_45_+1000_oovN2CUMgi6rRu0R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/audit.h between commit e23eb920b0f3 ("audit: export
audit_log_task_info") from the security tree and commit "audit.h: replace
defines with C stubs" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/audit.h
index 2a5073c,caf9179..0000000
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@@ -624,38 -623,92 +624,95 @@@ static inline void audit_mmap_fd(int fd
  extern int audit_n_rules;
  extern int audit_signals;
  #else /* CONFIG_AUDITSYSCALL */
- #define audit_alloc(t) ({ 0; })
- #define audit_free(t) do { ; } while (0)
- #define audit_syscall_entry(ta,a,b,c,d,e) do { ; } while (0)
- #define audit_syscall_exit(r) do { ; } while (0)
- #define audit_dummy_context() 1
- #define audit_getname(n) do { ; } while (0)
- #define audit_putname(n) do { ; } while (0)
- #define __audit_inode(n,d) do { ; } while (0)
- #define __audit_inode_child(i,p) do { ; } while (0)
- #define audit_inode(n,d) do { (void)(d); } while (0)
- #define audit_inode_child(i,p) do { ; } while (0)
- #define audit_core_dumps(i) do { ; } while (0)
- #define audit_seccomp(i,s,c) do { ; } while (0)
- #define auditsc_get_stamp(c,t,s) (0)
+ static inline int  audit_alloc(struct task_struct *task)
+ {
+ 	return 0;
+ }
+ static inline void audit_free(struct task_struct *task)
+ { }
+ static inline void audit_syscall_entry(int arch, int major, unsigned long=
 a0,
+ 				       unsigned long a1, unsigned long a2,
+ 				       unsigned long a3)
+ { }
+ static inline void audit_syscall_exit(void *pt_regs)
+ { }
+ static inline int audit_dummy_context(void)
+ {
+ 	return 1;
+ }
+ static inline void audit_getname(const char *name)
+ { }
+ static inline void audit_putname(const char *name)
+ { }
+ static inline void __audit_inode(const char *name, const struct dentry *d=
entry)
+ { }
+ static inline void __audit_inode_child(const struct dentry *dentry,
+ 					const struct inode *parent)
+ { }
+ static inline void audit_inode(const char *name, const struct dentry *den=
try)
+ { }
+ static inline void audit_inode_child(const struct dentry *dentry,
+ 				     const struct inode *parent)
+ { }
+ static inline void audit_core_dumps(long signr)
+ { }
+ static inline void __audit_seccomp(unsigned long syscall, long signr, int=
 code)
+ { }
+ static inline void audit_seccomp(unsigned long syscall, long signr, int c=
ode)
+ { }
+ static inline int auditsc_get_stamp(struct audit_context *ctx,
+ 			      struct timespec *t, unsigned int *serial)
+ {
+ 	return 0;
+ }
  #define audit_get_loginuid(t) (-1)
  #define audit_get_sessionid(t) (-1)
- #define audit_log_task_context(b) do { ; } while (0)
- #define audit_log_task_info(b, t) do { ; } while (0)
- #define audit_ipc_obj(i) ((void)0)
- #define audit_ipc_set_perm(q,u,g,m) ((void)0)
- #define audit_bprm(p) ({ 0; })
- #define audit_socketcall(n,a) ((void)0)
- #define audit_fd_pair(n,a) ((void)0)
- #define audit_sockaddr(len, addr) ({ 0; })
- #define audit_mq_open(o,m,a) ((void)0)
- #define audit_mq_sendrecv(d,l,p,t) ((void)0)
- #define audit_mq_notify(d,n) ((void)0)
- #define audit_mq_getsetattr(d,s) ((void)0)
- #define audit_log_bprm_fcaps(b, ncr, ocr) ({ 0; })
- #define audit_log_capset(pid, ncr, ocr) ((void)0)
- #define audit_mmap_fd(fd, flags) ((void)0)
- #define audit_ptrace(t) ((void)0)
+ static inline void audit_log_task_context(struct audit_buffer *ab)
+ { }
++static inline void audit_log_task_info(struct audit_buffer *ab,
++					struct task_struct *tsk)
++{ }
+ static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
+ { }
+ static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid,
+ 					gid_t gid, umode_t mode)
+ { }
+ static inline int audit_bprm(struct linux_binprm *bprm)
+ {
+ 	return 0;
+ }
+ static inline void audit_socketcall(int nargs, unsigned long *args)
+ { }
+ static inline void audit_fd_pair(int fd1, int fd2)
+ { }
+ static inline int audit_sockaddr(int len, void *addr)
+ {
+ 	return 0;
+ }
+ static inline void audit_mq_open(int oflag, umode_t mode, struct mq_attr =
*attr)
+ { }
+ static inline void audit_mq_sendrecv(mqd_t mqdes, size_t msg_len,
+ 				     unsigned int msg_prio,
+ 				     const struct timespec *abs_timeout)
+ { }
+ static inline void audit_mq_notify(mqd_t mqdes,
+ 				   const struct sigevent *notification)
+ { }
+ static inline void audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqsta=
t)
+ { }
+ static inline int audit_log_bprm_fcaps(struct linux_binprm *bprm,
+ 				       const struct cred *new,
+ 				       const struct cred *old)
+ {
+ 	return 0;
+ }
+ static inline void audit_log_capset(pid_t pid, const struct cred *new,
+ 				   const struct cred *old)
+ { }
+ static inline void audit_mmap_fd(int fd, int flags)
+ { }
+ static inline void audit_ptrace(struct task_struct *t)
+ { }
  #define audit_n_rules 0
  #define audit_signals 0
  #endif /* CONFIG_AUDITSYSCALL */

--Signature=_Mon__17_Sep_2012_20_35_45_+1000_oovN2CUMgi6rRu0R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVv0BAAoJEECxmPOUX5FEfjIP/1WlSEObbSTUaDQmBpW9RV1A
wt+3opRr1HbIEFFzdKBoE1kKdWSdMv49Uwt0ms0PsELWOyWgirSdwnyczPk/TWwz
s/CdD1qdHRMWE8lU5oe9pTSoTfkHUu9Zly6SznZ3qoClV+T1Tlg7PlqpWjjBCJSO
a5ORXr2OMN/zpxg8t1J+2eprsU3+A2YYltbRPAZMonMWI+igBbqyvx4hWONpOrjk
JzSSI09j1ogdob64HCe+3RhrMOJxlyMjh24RQPjva1ZQJJT+KvZm2g/cEm0gO+tg
nwiDhxe0G4z1EQXvJ2GvGZiuhR2n3jgcWkXsxn0woyyGLnEdspVwsEOsaU3IA2wl
8Ue44hoJdRmXekI9OCPZQc1ZJ3xDSZGL2gEghLNP2nRAplV2WgPhWvA9cyZBUdlO
1dF56XbxvhPQ5ejOBK6VbK/YFui6x3lfg0Vs7+lfIE+2nXmB4C+r7XGxScHbTt+D
oqV4kmrXeROrUDqNeUFDDpjdTNRWmhtfpZxR8OxaXnmzEMAMhIqGVQt/8Zwcywfh
7dqt0XVzYmkESVXWcYufOVACI5Z25nPgEZURYjCO02ye7THmYoCQ7QRH2Ge06D8Q
x+LSiqDG1X7rK7oIQwaU+0/XL3Lr5Gu8Xto5zRxYuHRAKWjreRpD7JIcGAReBpLQ
sLw5YxHN1OnCull269hu
=PZWT
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_20_35_45_+1000_oovN2CUMgi6rRu0R--
