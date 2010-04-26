Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0DZFDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 01:03:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53812 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0DZFDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 01:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GzpYkxopwA+oxYFhzyv6ErUgXHBza+fYSBoWqMWmPM3uNINvxXNaGQEJvVJYSOMYit
         m5tb+3g7gyCXEUJR0xoVDn0+IDvo+hedAhEokev+at8YcQUPpw0Zb8KUesyXiCP2EI49
         pajPZnuxUbqz0Xky7rBRIhN62uIJy0TJSsXo8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] security:whitespace coding style fixes(part2)
Date: Sun, 25 Apr 2010 22:03:28 -0700
Message-Id: <1272258208-2570-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the rest of the security branch with minor
whitespace fixes with using (L)indent.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 security/keys/process_keys.c     |   12 ++++++------
 security/keys/request_key.c      |    4 ++--
 security/keys/request_key_auth.c |    5 ++---
 security/lsm_audit.c             |    1 -
 security/security.c              |    6 +++---
 security/selinux/hooks.c         |    4 ++--
 security/selinux/selinuxfs.c     |   10 +++++-----
 security/selinux/xfrm.c          |    4 +---
 security/smack/smack_lsm.c       |   12 +++---------
 security/smack/smackfs.c         |    2 --
 security/tomoyo/common.c         |   16 ++++++++--------
 security/tomoyo/domain.c         |   10 +++++-----
 security/tomoyo/file.c           |   18 +++++++++---------
 security/tomoyo/gc.c             |    1 -
 security/tomoyo/realpath.c       |   14 +++++++-------
 security/tomoyo/tomoyo.c         |    2 +-
 16 files changed, 54 insertions(+), 67 deletions(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 06c2ccf..54e0be4 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -790,13 +790,13 @@ void key_replace_session_keyring(void)
 		return;
 
 	old = current_cred();
-	new->  uid	= old->  uid;
-	new-> euid	= old-> euid;
-	new-> suid	= old-> suid;
+	new->uid	= old->uid;
+	new->euid	= old->euid;
+	new->suid	= old->suid;
 	new->fsuid	= old->fsuid;
-	new->  gid	= old->  gid;
-	new-> egid	= old-> egid;
-	new-> sgid	= old-> sgid;
+	new->gid	= old->gid;
+	new->egid	= old->egid;
+	new->sgid	= old->sgid;
 	new->fsgid	= old->fsgid;
 	new->user	= get_uid(old->user);
 	new->group_info	= get_group_info(old->group_info);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 03fe63e..d99a235 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -128,7 +128,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 	/* set up the argument list */
 	i = 0;
 	argv[i++] = "/sbin/request-key";
-	argv[i++] = (char *) op;
+	argv[i++] = (char *)op;
 	argv[i++] = key_str;
 	argv[i++] = uid_str;
 	argv[i++] = gid_str;
@@ -430,7 +430,7 @@ struct key *request_key_and_link(struct key_type *type,
 		key = key_ref_to_ptr(key_ref);
 	} else if (PTR_ERR(key_ref) != -EAGAIN) {
 		key = ERR_CAST(key_ref);
-	} else  {
+	} else {
 		/* the search failed, but the keyrings were searchable, so we
 		 * should consult userspace if we can */
 		key = ERR_PTR(-ENOKEY);
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 8674715..00baded 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -46,7 +46,7 @@ static int request_key_auth_instantiate(struct key *key,
 					const void *data,
 					size_t datalen)
 {
-	key->payload.data = (struct request_key_auth *) data;
+	key->payload.data = (struct request_key_auth *)data;
 	return 0;
 
 } /* end request_key_auth_instantiate() */
@@ -179,8 +179,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 		rka->pid = irka->pid;
 
 		up_read(&cred->request_key_auth->sem);
-	}
-	else {
+	} else {
 		/* it isn't - use this process as the context */
 		rka->cred = get_cred(cred);
 		rka->pid = current->pid;
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 893365b..503a55e 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -182,7 +182,6 @@ int ipv6_skb_to_auditdata(struct sk_buff *skb,
 }
 #endif
 
-
 static inline void print_ipv6_addr(struct audit_buffer *ab,
 				   struct in6_addr *addr, __be16 port,
 				   char *name1, char *name2)
diff --git a/security/security.c b/security/security.c
index 687c6fd..07bbbaa 100644
--- a/security/security.c
+++ b/security/security.c
@@ -27,7 +27,7 @@ extern void security_fixup_ops(struct security_operations *ops);
 
 static struct security_operations *security_ops;
 static struct security_operations default_security_ops = {
-	.name	= "default",
+	.name = "default",
 };
 
 static inline int verify(struct security_operations *ops)
@@ -371,7 +371,7 @@ int security_inode_alloc(struct inode *inode)
 	int ret;
 
 	inode->i_security = NULL;
-	ret =  security_ops->inode_alloc_security(inode);
+	ret = security_ops->inode_alloc_security(inode);
 	if (ret)
 		return ret;
 	ret = ima_inode_alloc(inode);
@@ -1051,7 +1051,7 @@ int security_unix_stream_connect(struct socket *sock, struct socket *other,
 }
 EXPORT_SYMBOL(security_unix_stream_connect);
 
-int security_unix_may_send(struct socket *sock,  struct socket *other)
+int security_unix_may_send(struct socket *sock, struct socket *other)
 {
 	return security_ops->unix_may_send(sock, other);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5feecb4..2ef1e09 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -153,7 +153,7 @@ static int selinux_secmark_enabled(void)
  */
 static void cred_init_security(void)
 {
-	struct cred *cred = (struct cred *) current->real_cred;
+	struct cred *cred = (struct cred *)current->real_cred;
 	struct task_security_struct *tsec;
 
 	tsec = kzalloc(sizeof(struct task_security_struct), GFP_KERNEL);
@@ -441,7 +441,7 @@ static int sb_finish_set_opts(struct super_block *sb)
 	    sbsec->behavior > ARRAY_SIZE(labeling_behaviors))
 		sbsec->flags &= ~SE_SBLABELSUPP;
 
-	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
+	/* Special handling for sysfs. Is genfs but also has setxattr handler */
 	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
 		sbsec->flags |= SE_SBLABELSUPP;
 
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index cd191bb..93e896c 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -174,7 +174,7 @@ static ssize_t sel_write_enforce(struct file *file, const char __user *buf,
 	}
 	length = count;
 out:
-	free_page((unsigned long) page);
+	free_page((unsigned long)page);
 	return length;
 }
 #else
@@ -242,7 +242,7 @@ static ssize_t sel_write_disable(struct file *file, const char __user *buf,
 
 	length = count;
 out:
-	free_page((unsigned long) page);
+	free_page((unsigned long)page);
 	return length;
 }
 #else
@@ -431,7 +431,7 @@ static ssize_t sel_write_checkreqprot(struct file *file, const char __user *buf,
 	selinux_checkreqprot = new_value ? 1 : 0;
 	length = count;
 out:
-	free_page((unsigned long) page);
+	free_page((unsigned long)page);
 	return length;
 }
 static const struct file_operations sel_checkreqprot_ops = {
@@ -876,7 +876,7 @@ static ssize_t sel_write_bool(struct file *filep, const char __user *buf,
 out:
 	mutex_unlock(&sel_mutex);
 	if (page)
-		free_page((unsigned long) page);
+		free_page((unsigned long)page);
 	return length;
 }
 
@@ -929,7 +929,7 @@ static ssize_t sel_commit_bools_write(struct file *filep,
 out:
 	mutex_unlock(&sel_mutex);
 	if (page)
-		free_page((unsigned long) page);
+		free_page((unsigned long)page);
 	return length;
 }
 
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index fff78d3..1a8ca45 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -97,8 +97,7 @@ int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
 		return 0;
 
 	rc = avc_has_perm(fl_secid, sel_sid, SECCLASS_ASSOCIATION,
-			  ASSOCIATION__POLMATCH,
-			  NULL);
+			  ASSOCIATION__POLMATCH, NULL);
 
 	if (rc == -EACCES)
 		return -ESRCH;
@@ -298,7 +297,6 @@ int selinux_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
 	return err;
 }
 
-
 /*
  * LSM hook implementation that copies security data structure from old to
  * new for policy cloning.
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index fdfeaa2..00fd961 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -176,7 +176,6 @@ static int smack_syslog(int type, bool from_file)
 	return rc;
 }
 
-
 /*
  * Superblock Hooks.
  */
@@ -831,7 +830,6 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	return rc;
 }
 
-
 /**
  * smack_inode_listsecurity - list the Smack attributes
  * @inode: the object
@@ -1089,7 +1087,6 @@ static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 	return 0;
 }
 
-
 /**
  * smack_cred_free - "free" task-level security credentials
  * @cred: the credentials in question
@@ -1388,7 +1385,7 @@ static int smack_task_wait(struct task_struct *p)
 	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
 		rc = 0;
 	/* we log only if we didn't get overriden */
- out_log:
+out_log:
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, p);
 	smack_log(sp, tsp, MAY_WRITE, rc, &ad);
@@ -2483,7 +2480,7 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
 static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 				int size)
 {
-	struct sockaddr_in *sip = (struct sockaddr_in *) msg->msg_name;
+	struct sockaddr_in *sip = (struct sockaddr_in *)msg->msg_name;
 
 	/*
 	 * Perfectly reasonable for this to be NULL
@@ -2494,7 +2491,6 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 	return smack_netlabel_send(sock->sk, sip);
 }
 
-
 /**
  * smack_from_secattr - Convert a netlabel attr.mls.lvl/attr.mls.cat pair to smack
  * @sap: netlabel secattr
@@ -2649,7 +2645,6 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
 	return rc;
 }
 
-
 /**
  * smack_socket_getpeersec_dgram - pull in packet label
  * @sock: the socket
@@ -2660,7 +2655,6 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
  */
 static int smack_socket_getpeersec_dgram(struct socket *sock,
 					 struct sk_buff *skb, u32 *secid)
-
 {
 	struct netlbl_lsm_secattr secattr;
 	struct sock *sk;
@@ -3235,7 +3229,7 @@ static __init int smack_init(void)
 	/*
 	 * Set the security state for the initial task.
 	 */
-	cred = (struct cred *) current->cred;
+	cred = (struct cred *)current->cred;
 	cred->security = &smack_known_floor.smk_known;
 
 	/* initilize the smack_know_list */
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index a2b72d7..3fb5ec7 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -90,7 +90,6 @@ static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
 const char *smack_cipso_option = SMACK_CIPSO_OPTION;
 
-
 #define	SEQ_READ_FINISHED	1
 
 /*
@@ -759,7 +758,6 @@ static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
 	}
 }
 
-
 /**
  * smk_write_netlbladdr - write() for /smack/netlabel
  * @file: file pointer, not actually used
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 975c45d..06fcf54 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -280,7 +280,7 @@ bool tomoyo_is_correct_path(const char *filename, const s8 start_type,
 	if (in_repetition)
 		goto out;
 	return true;
- out:
+out:
 	return false;
 }
 
@@ -336,7 +336,7 @@ bool tomoyo_is_correct_domain(const unsigned char *domainname)
 		}
 	} while (*domainname);
 	return true;
- out:
+out:
 	return false;
 }
 
@@ -631,7 +631,7 @@ static bool tomoyo_path_matches_pattern2(const char *f, const char *p)
 	       (*(p + 1) == '*' || *(p + 1) == '@'))
 		p += 2;
 	return !*f && !*p;
- recursive:
+recursive:
 	/*
 	 * The "\{" pattern is permitted only after '/' character.
 	 * This guarantees that below "*(p - 1)" is safe.
@@ -894,7 +894,7 @@ static struct tomoyo_profile *tomoyo_find_or_assign_new_profile(const unsigned
 		ptr->value[i] = tomoyo_control_array[i].current_value;
 	mb(); /* Avoid out-of-order execution. */
 	tomoyo_profile_ptr[profile] = ptr;
- ok:
+ok:
 	mutex_unlock(&lock);
 	return ptr;
 }
@@ -1390,7 +1390,7 @@ static bool tomoyo_print_path_acl(struct tomoyo_io_buffer *head,
 	}
 	head->read_bit = 0;
 	return true;
- out:
+out:
 	head->read_bit = bit;
 	head->read_avail = pos;
 	return false;
@@ -1429,7 +1429,7 @@ static bool tomoyo_print_path2_acl(struct tomoyo_io_buffer *head,
 	}
 	head->read_bit = 0;
 	return true;
- out:
+out:
 	head->read_bit = bit;
 	head->read_avail = pos;
 	return false;
@@ -1618,7 +1618,7 @@ static int tomoyo_write_pid(struct tomoyo_io_buffer *head)
 	unsigned long pid;
 	/* No error check. */
 	strict_strtoul(head->write_buf, 10, &pid);
-	head->read_step = (int) pid;
+	head->read_step = (int)pid;
 	head->read_eof = false;
 	return 0;
 }
@@ -2022,7 +2022,7 @@ static int tomoyo_read_control(struct file *file, char __user *buffer,
 	}
 	head->read_avail -= len;
 	memmove(cp, cp + len, head->read_avail);
- out:
+out:
 	mutex_unlock(&head->io_sem);
 	return len;
 }
diff --git a/security/tomoyo/domain.c b/security/tomoyo/domain.c
index acb8c39..14dc198 100644
--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -177,7 +177,7 @@ static int tomoyo_update_domain_initializer_entry(const char *domainname,
 		error = 0;
 	}
 	mutex_unlock(&tomoyo_policy_lock);
- out:
+out:
 	tomoyo_put_name(saved_domainname);
 	tomoyo_put_name(saved_program);
 	kfree(entry);
@@ -396,7 +396,7 @@ static int tomoyo_update_domain_keeper_entry(const char *domainname,
 		error = 0;
 	}
 	mutex_unlock(&tomoyo_policy_lock);
- out:
+out:
 	tomoyo_put_name(saved_domainname);
 	tomoyo_put_name(saved_program);
 	kfree(entry);
@@ -585,7 +585,7 @@ static int tomoyo_update_alias_entry(const char *original_name,
 		error = 0;
 	}
 	mutex_unlock(&tomoyo_policy_lock);
- out:
+out:
 	tomoyo_put_name(saved_original_name);
 	tomoyo_put_name(saved_aliased_name);
 	kfree(entry);
@@ -806,7 +806,7 @@ int tomoyo_find_next_domain(struct linux_binprm *bprm)
 		goto done;
 	domain = tomoyo_find_or_assign_new_domain(new_domain_name,
 						  old_domain->profile);
- done:
+done:
 	if (domain)
 		goto out;
 	printk(KERN_WARNING "TOMOYO-ERROR: Domain '%s' not defined.\n",
@@ -815,7 +815,7 @@ int tomoyo_find_next_domain(struct linux_binprm *bprm)
 		retval = -EPERM;
 	else
 		old_domain->transition_failed = true;
- out:
+out:
 	if (!domain)
 		domain = old_domain;
 	/* Update reference count on "struct tomoyo_domain_info". */
diff --git a/security/tomoyo/file.c b/security/tomoyo/file.c
index 6f3fe76..7476df5 100644
--- a/security/tomoyo/file.c
+++ b/security/tomoyo/file.c
@@ -339,7 +339,7 @@ static int tomoyo_update_file_pattern_entry(const char *pattern,
 		error = 0;
 	}
 	mutex_unlock(&tomoyo_policy_lock);
- out:
+out:
 	kfree(entry);
 	tomoyo_put_name(saved_pattern);
 	return error;
@@ -785,7 +785,7 @@ int tomoyo_write_file_policy(char *data, struct tomoyo_domain_info *domain,
 		return tomoyo_update_path2_acl(type, filename, filename2,
 					       domain, is_delete);
 	}
- out:
+out:
 	return -EINVAL;
 }
 
@@ -936,7 +936,7 @@ static int tomoyo_update_path2_acl(const u8 type, const char *filename1,
 		error = 0;
 	}
 	mutex_unlock(&tomoyo_policy_lock);
- out:
+out:
 	tomoyo_put_name(saved_filename1);
 	tomoyo_put_name(saved_filename2);
 	kfree(entry);
@@ -1025,7 +1025,7 @@ static int tomoyo_path_permission2(struct tomoyo_domain_info *const domain,
 
 	if (!mode)
 		return 0;
- next:
+next:
 	error = tomoyo_path_acl(domain, operation, filename);
 	msg = tomoyo_path2keyword(operation);
 	if (!error)
@@ -1040,7 +1040,7 @@ static int tomoyo_path_permission2(struct tomoyo_domain_info *const domain,
 	}
 	if (!is_enforce)
 		error = 0;
- ok:
+ok:
 	/*
 	 * Since "allow_truncate" doesn't imply "allow_rewrite" permission,
 	 * we need to check "allow_rewrite" permission if the filename is
@@ -1125,7 +1125,7 @@ int tomoyo_check_open_permission(struct tomoyo_domain_info *domain,
 	if (!error && (flag & O_TRUNC))
 		error = tomoyo_path_permission2(domain, TOMOYO_TYPE_TRUNCATE,
 						buf, mode);
- out:
+out:
 	kfree(buf);
 	tomoyo_read_unlock(idx);
 	if (!is_enforce)
@@ -1169,7 +1169,7 @@ int tomoyo_path_perm(const u8 operation, struct path *path)
 		}
 	}
 	error = tomoyo_path_permission2(domain, operation, buf, mode);
- out:
+out:
 	kfree(buf);
 	tomoyo_read_unlock(idx);
 	if (!is_enforce)
@@ -1205,7 +1205,7 @@ int tomoyo_check_rewrite_permission(struct file *filp)
 		goto out;
 	}
 	error = tomoyo_path_permission2(domain, TOMOYO_TYPE_REWRITE, buf, mode);
- out:
+out:
 	kfree(buf);
 	tomoyo_read_unlock(idx);
 	if (!is_enforce)
@@ -1271,7 +1271,7 @@ int tomoyo_path2_perm(const u8 operation, struct path *path1,
 		tomoyo_update_path2_acl(operation, name1, name2, domain,
 					false);
 	}
- out:
+out:
 	kfree(buf1);
 	kfree(buf2);
 	tomoyo_read_unlock(idx);
diff --git a/security/tomoyo/gc.c b/security/tomoyo/gc.c
index d9ad35b..9076307 100644
--- a/security/tomoyo/gc.c
+++ b/security/tomoyo/gc.c
@@ -144,7 +144,6 @@ static bool tomoyo_del_domain(struct tomoyo_domain_info *domain)
 	return true;
 }
 
-
 static void tomoyo_del_name(const struct tomoyo_name_entry *ptr)
 {
 }
diff --git a/security/tomoyo/realpath.c b/security/tomoyo/realpath.c
index c225c65..401fc7b 100644
--- a/security/tomoyo/realpath.c
+++ b/security/tomoyo/realpath.c
@@ -30,17 +30,17 @@
 int tomoyo_encode(char *buffer, int buflen, const char *str)
 {
 	while (1) {
-		const unsigned char c = *(unsigned char *) str++;
+		const unsigned char c = *(unsigned char *)str++;
 
 		if (tomoyo_is_valid(c)) {
 			if (--buflen <= 0)
 				break;
-			*buffer++ = (char) c;
+			*buffer++ = (char)c;
 			if (c != '\\')
 				continue;
 			if (--buflen <= 0)
 				break;
-			*buffer++ = (char) c;
+			*buffer++ = (char)c;
 			continue;
 		}
 		if (!c) {
@@ -261,7 +261,7 @@ const struct tomoyo_path_info *tomoyo_get_name(const char *name)
 	if (!name)
 		return NULL;
 	len = strlen(name) + 1;
-	hash = full_name_hash((const unsigned char *) name, len - 1);
+	hash = full_name_hash((const unsigned char *)name, len - 1);
 	head = &tomoyo_name_list[hash_long(hash, TOMOYO_HASH_BITS)];
 	mutex_lock(&tomoyo_name_list_lock);
 	list_for_each_entry(ptr, head, list) {
@@ -284,12 +284,12 @@ const struct tomoyo_path_info *tomoyo_get_name(const char *name)
 		goto out;
 	}
 	atomic_add(allocated_len, &tomoyo_policy_memory_size);
-	ptr->entry.name = ((char *) ptr) + sizeof(*ptr);
-	memmove((char *) ptr->entry.name, name, len);
+	ptr->entry.name = ((char *)ptr) + sizeof(*ptr);
+	memmove((char *)ptr->entry.name, name, len);
 	atomic_set(&ptr->users, 1);
 	tomoyo_fill_path_info(&ptr->entry);
 	list_add_tail(&ptr->list, head);
- out:
+out:
 	mutex_unlock(&tomoyo_name_list_lock);
 	return ptr ? &ptr->entry : NULL;
 }
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index dedd97d..cf12f42 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -267,7 +267,7 @@ struct srcu_struct tomoyo_ss;
 
 static int __init tomoyo_init(void)
 {
-	struct cred *cred = (struct cred *) current_cred();
+	struct cred *cred = (struct cred *)current_cred();
 
 	if (!security_module_enable(&tomoyo_security_ops))
 		return 0;
-- 
1.6.5.GIT

