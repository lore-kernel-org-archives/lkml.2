Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2IXMxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:53:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38325 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2IXMxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:53:50 -0400
Date: Mon, 24 Sep 2012 22:53:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: linux-next: manual merge of the akpm tree with the userns tree
Message-Id: <20120924225335.55833aca0e02151b15c9317b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_22_53_35_+1000_BJeD0._YvacRwWZS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_22_53_35_+1000_BJeD0._YvacRwWZS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/audit.h between commit e1760bd5ffae ("userns: Convert the
audit loginuid  to be a kuid") from the userns tree and commit "audit.h:
replace defines with C stubs" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/audit.h
index a7a7db9,5c186a5..0000000
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@@ -627,38 -624,95 +627,95 @@@ static inline void audit_mmap_fd(int fd
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
 -#define audit_get_loginuid(t) (-1)
 +#define audit_get_loginuid(t) (INVALID_UID)
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
+ static inline void audit_log_task_info(struct audit_buffer *ab,
+ 				       struct task_struct *tsk)
+ { }
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
@@@ -705,28 -759,56 +762,56 @@@ static inline void	    audit_log_secctx
  extern int		    audit_update_lsm_rules(void);
 =20
  				/* Private API (for audit.c only) */
 -extern int audit_filter_user(struct netlink_skb_parms *cb);
 +extern int audit_filter_user(void);
  extern int audit_filter_type(int type);
 -extern int  audit_receive_filter(int type, int pid, int uid, int seq,
 -				void *data, size_t datasz, uid_t loginuid,
 +extern int  audit_receive_filter(int type, int pid, int seq,
 +				void *data, size_t datasz, kuid_t loginuid,
  				u32 sessionid, u32 sid);
  extern int audit_enabled;
- #else
- #define audit_log(c,g,t,f,...) do { ; } while (0)
- #define audit_log_start(c,g,t) ({ NULL; })
- #define audit_log_vformat(b,f,a) do { ; } while (0)
- #define audit_log_format(b,f,...) do { ; } while (0)
- #define audit_log_end(b) do { ; } while (0)
- #define audit_log_n_hex(a,b,l) do { ; } while (0)
- #define audit_log_n_string(a,c,l) do { ; } while (0)
- #define audit_log_string(a,c) do { ; } while (0)
- #define audit_log_n_untrustedstring(a,n,s) do { ; } while (0)
- #define audit_log_untrustedstring(a,s) do { ; } while (0)
- #define audit_log_d_path(b, p, d) do { ; } while (0)
- #define audit_log_key(b, k) do { ; } while (0)
- #define audit_log_link_denied(o, l) do { ; } while (0)
- #define audit_log_secctx(b,s) do { ; } while (0)
+ #else /* CONFIG_AUDIT */
+ static inline __printf(4, 5)
+ void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
+ 	       const char *fmt, ...)
+ { }
+ static inline struct audit_buffer *audit_log_start(struct audit_context *=
ctx,
+ 						   gfp_t gfp_mask, int type)
+ {
+ 	return NULL;
+ }
+ static inline __printf(2, 3)
+ void audit_log_format(struct audit_buffer *ab, const char *fmt, ...)
+ { }
+ static inline void audit_log_end(struct audit_buffer *ab)
+ { }
+ static inline void audit_log_n_hex(struct audit_buffer *ab,
+ 				   const unsigned char *buf, size_t len)
+ { }
+ static inline void audit_log_n_string(struct audit_buffer *ab,
+ 				      const char *buf, size_t n)
+ { }
+ static inline void  audit_log_n_untrustedstring(struct audit_buffer *ab,
+ 						const char *string, size_t n)
+ { }
+ static inline void audit_log_untrustedstring(struct audit_buffer *ab,
+ 					     const char *string)
+ { }
+ static inline void audit_log_d_path(struct audit_buffer *ab,
+ 				    const char *prefix,
+ 				    const struct path *path)
+ { }
+ static inline void audit_log_key(struct audit_buffer *ab, char *key)
+ { }
+ static inline void audit_log_link_denied(const char *string,
+ 					 const struct path *link)
+ { }
+ static inline void audit_log_secctx(struct audit_buffer *ab, u32 secid)
+ { }
  #define audit_enabled 0
- #endif
+ #endif /* CONFIG_AUDIT */
+ static inline void audit_log_string(struct audit_buffer *ab, const char *=
buf)
+ {
+ 	audit_log_n_string(ab, buf, strlen(buf));
+ }
+=20
  #endif
  #endif

--Signature=_Mon__24_Sep_2012_22_53_35_+1000_BJeD0._YvacRwWZS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYFfPAAoJEECxmPOUX5FELdgP/2bcum8ox7PToYzVdBc0AAJh
VPxssDznG+cXlPekEks7LYEuzV87Eptx3x7jz7qCDiDHnxJmLSs/W2Rhg94aefn1
ZwXw9+lLCHR5SAmNygVzb0nAQpZuM0eMajtFxtiq5tBCrqYzX/UT5Ha2owSUvgXL
Ii4QEuRaj52Ea2dmevVq2JqpsY8IUK0ZqDUTEXOQZzZIMq7vu0L8xKjd3kjWen33
/eaq8y/C64pTPxGdhojkLfU+722m6zqt6g7Cy6P520jDZhz0op8Z2BBqNvUYh+0U
SON0T7SYJQXiIbpzsLMdlU7KJGzV31Zo9s3+e4ZJv2Yi6+zqGDNDW9HPhmVYDDKQ
IBivJt/Kayf/X4fl8wXMEKCvyITz4jHwGZgYmdtnBwEjjU/dhZK2qtvhOOASfgNG
kR6UoRKquE2bxnHiHNgwkLIfHc9ChBfIM+CGT8OGIybX5mECmDLCtXXRULmJs3TU
MWIa6oKbDJgK5rVEYWLVSpxfRI8QcMgulRA0gUuETsqfSRXdtw5NaXdi1eduuciL
ey48bWKrgceCF3uhNCK+lOhFOmxzqI1tuKZgFdP/i+0c7W9Ix7Sivp8ujfdoZR/Y
cMiTX1XgSbGVNMb8jWixQJibg5e55BMEObVKIoAdaccdaVz88nR8cjuMvHDri/91
gDik7N4s5lEAjoSMbsjI
=yXrh
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_22_53_35_+1000_BJeD0._YvacRwWZS--
