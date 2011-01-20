Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab1ATQil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:38:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1ATQij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:38:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] KEYS: Do some style cleanup in the key management code.
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Thu, 20 Jan 2011 16:38:27 +0000
Message-ID: <20110120163827.9797.35696.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a bit of a style clean up in the key management code.  No functional changes.

Done using:

perl -p -i -e 's!^/[*]*/\n!!' security/keys/*.c
perl -p -i -e 's!} /[*] end [a-z0-9_]*[(][)] [*]/\n!}\n!' security/keys/*.c
sed -i -s -e ": next" -e N -e 's/^\n[}]$/}/' -e t -e P -e 's/^.*\n//' -e "b next" security/keys/*.c

To remove /*****/ lines, remove comments on the closing brace of a function to
name the function and remove blank lines before the closing brace of a function.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/compat.c            |    4 --
 security/keys/encrypted_defined.c |    1 
 security/keys/key.c               |   80 +++++++++----------------------------
 security/keys/keyctl.c            |   77 +++++++++---------------------------
 security/keys/keyring.c           |   64 +++++++-----------------------
 security/keys/permission.c        |    8 +---
 security/keys/proc.c              |    7 ---
 security/keys/process_keys.c      |   23 ++---------
 security/keys/request_key_auth.c  |   32 ++++-----------
 security/keys/user_defined.c      |   32 ++++-----------
 10 files changed, 80 insertions(+), 248 deletions(-)

diff --git a/security/keys/compat.c b/security/keys/compat.c
index 792c0a6..3cedf63 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -14,7 +14,6 @@
 #include <linux/compat.h>
 #include "internal.h"
 
-/*****************************************************************************/
 /*
  * the key control system call, 32-bit compatibility version for 64-bit archs
  * - this should only be called if the 64-bit arch uses weird pointers in
@@ -88,5 +87,4 @@ asmlinkage long compat_sys_keyctl(u32 option,
 	default:
 		return -EOPNOTSUPP;
 	}
-
-} /* end compat_sys_keyctl() */
+}
diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_defined.c
index 32d27c8..28791a6 100644
--- a/security/keys/encrypted_defined.c
+++ b/security/keys/encrypted_defined.c
@@ -888,7 +888,6 @@ static int __init init_encrypted(void)
 out:
 	encrypted_shash_release();
 	return ret;
-
 }
 
 static void __exit cleanup_encrypted(void)
diff --git a/security/keys/key.c b/security/keys/key.c
index c1eac80..3a92d73 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -56,7 +56,6 @@ void __key_check(const struct key *key)
 }
 #endif
 
-/*****************************************************************************/
 /*
  * get the key quota record for a user, allocating a new record if one doesn't
  * already exist
@@ -130,10 +129,8 @@ struct key_user *key_user_lookup(uid_t uid, struct user_namespace *user_ns)
 	kfree(candidate);
  out:
 	return user;
+}
 
-} /* end key_user_lookup() */
-
-/*****************************************************************************/
 /*
  * dispose of a user structure
  */
@@ -146,10 +143,8 @@ void key_user_put(struct key_user *user)
 
 		kfree(user);
 	}
+}
 
-} /* end key_user_put() */
-
-/*****************************************************************************/
 /*
  * assign a key the next unique serial number
  * - these are assigned randomly to avoid security issues through covert
@@ -211,10 +206,8 @@ serial_exists:
 		if (key->serial < xkey->serial)
 			goto attempt_insertion;
 	}
+}
 
-} /* end key_alloc_serial() */
-
-/*****************************************************************************/
 /*
  * allocate a key of the specified type
  * - update the user's quota to reflect the existence of the key
@@ -344,12 +337,10 @@ no_quota:
 	key_user_put(user);
 	key = ERR_PTR(-EDQUOT);
 	goto error;
-
-} /* end key_alloc() */
+}
 
 EXPORT_SYMBOL(key_alloc);
 
-/*****************************************************************************/
 /*
  * reserve an amount of quota for the key's payload
  */
@@ -384,12 +375,10 @@ int key_payload_reserve(struct key *key, size_t datalen)
 		key->datalen = datalen;
 
 	return ret;
-
-} /* end key_payload_reserve() */
+}
 
 EXPORT_SYMBOL(key_payload_reserve);
 
-/*****************************************************************************/
 /*
  * instantiate a key and link it into the target keyring atomically
  * - called with the target keyring's semaphore writelocked
@@ -441,10 +430,8 @@ static int __key_instantiate_and_link(struct key *key,
 		wake_up_bit(&key->flags, KEY_FLAG_USER_CONSTRUCT);
 
 	return ret;
+}
 
-} /* end __key_instantiate_and_link() */
-
-/*****************************************************************************/
 /*
  * instantiate a key and link it into the target keyring atomically
  */
@@ -471,12 +458,10 @@ int key_instantiate_and_link(struct key *key,
 		__key_link_end(keyring, key->type, prealloc);
 
 	return ret;
-
-} /* end key_instantiate_and_link() */
+}
 
 EXPORT_SYMBOL(key_instantiate_and_link);
 
-/*****************************************************************************/
 /*
  * negatively instantiate a key and link it into the target keyring atomically
  */
@@ -535,12 +520,10 @@ int key_negate_and_link(struct key *key,
 		wake_up_bit(&key->flags, KEY_FLAG_USER_CONSTRUCT);
 
 	return ret == 0 ? link_ret : ret;
-
-} /* end key_negate_and_link() */
+}
 
 EXPORT_SYMBOL(key_negate_and_link);
 
-/*****************************************************************************/
 /*
  * do cleaning up in process context so that we don't have to disable
  * interrupts all over the place
@@ -601,10 +584,8 @@ static void key_cleanup(struct work_struct *work)
 
 	/* there may, of course, be more than one key to destroy */
 	goto go_again;
+}
 
-} /* end key_cleanup() */
-
-/*****************************************************************************/
 /*
  * dispose of a reference to a key
  * - when all the references are gone, we schedule the cleanup task to come and
@@ -618,12 +599,10 @@ void key_put(struct key *key)
 		if (atomic_dec_and_test(&key->usage))
 			schedule_work(&key_cleanup_task);
 	}
-
-} /* end key_put() */
+}
 
 EXPORT_SYMBOL(key_put);
 
-/*****************************************************************************/
 /*
  * find a key by its serial number
  */
@@ -664,10 +643,8 @@ struct key *key_lookup(key_serial_t id)
  error:
 	spin_unlock(&key_serial_lock);
 	return key;
+}
 
-} /* end key_lookup() */
-
-/*****************************************************************************/
 /*
  * find and lock the specified key type against removal
  * - we return with the sem readlocked
@@ -690,20 +667,16 @@ struct key_type *key_type_lookup(const char *type)
 
  found_kernel_type:
 	return ktype;
+}
 
-} /* end key_type_lookup() */
-
-/*****************************************************************************/
 /*
  * unlock a key type
  */
 void key_type_put(struct key_type *ktype)
 {
 	up_read(&key_types_sem);
+}
 
-} /* end key_type_put() */
-
-/*****************************************************************************/
 /*
  * attempt to update an existing key
  * - the key has an incremented refcount
@@ -742,10 +715,8 @@ error:
 	key_put(key);
 	key_ref = ERR_PTR(ret);
 	goto out;
+}
 
-} /* end __key_update() */
-
-/*****************************************************************************/
 /*
  * search the specified keyring for a key of the same description; if one is
  * found, update it, otherwise add a new one
@@ -855,12 +826,10 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 
 	key_ref = __key_update(key_ref, payload, plen);
 	goto error;
-
-} /* end key_create_or_update() */
+}
 
 EXPORT_SYMBOL(key_create_or_update);
 
-/*****************************************************************************/
 /*
  * update a key
  */
@@ -891,12 +860,10 @@ int key_update(key_ref_t key_ref, const void *payload, size_t plen)
 
  error:
 	return ret;
-
-} /* end key_update() */
+}
 
 EXPORT_SYMBOL(key_update);
 
-/*****************************************************************************/
 /*
  * revoke a key
  */
@@ -926,12 +893,10 @@ void key_revoke(struct key *key)
 	}
 
 	up_write(&key->sem);
-
-} /* end key_revoke() */
+}
 
 EXPORT_SYMBOL(key_revoke);
 
-/*****************************************************************************/
 /*
  * register a type of key
  */
@@ -956,12 +921,10 @@ int register_key_type(struct key_type *ktype)
  out:
 	up_write(&key_types_sem);
 	return ret;
-
-} /* end register_key_type() */
+}
 
 EXPORT_SYMBOL(register_key_type);
 
-/*****************************************************************************/
 /*
  * unregister a type of key
  */
@@ -1010,12 +973,10 @@ void unregister_key_type(struct key_type *ktype)
 	up_write(&key_types_sem);
 
 	key_schedule_gc(0);
-
-} /* end unregister_key_type() */
+}
 
 EXPORT_SYMBOL(unregister_key_type);
 
-/*****************************************************************************/
 /*
  * initialise the key management stuff
  */
@@ -1037,5 +998,4 @@ void __init key_init(void)
 
 	rb_insert_color(&root_key_user.node,
 			&key_user_tree);
-
-} /* end key_init() */
+}
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 60924f6..83ec98b7 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -46,7 +46,6 @@ static int key_get_type_from_user(char *type,
 	return 0;
 }
 
-/*****************************************************************************/
 /*
  * extract the description of a new key from userspace and either add it as a
  * new key to the specified keyring or update a matching key in that keyring
@@ -132,10 +131,8 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 	kfree(description);
  error:
 	return ret;
+}
 
-} /* end sys_add_key() */
-
-/*****************************************************************************/
 /*
  * search the process keyrings for a matching key
  * - nested keyrings may also be searched if they have Search permission
@@ -222,10 +219,8 @@ error2:
 	kfree(description);
 error:
 	return ret;
+}
 
-} /* end sys_request_key() */
-
-/*****************************************************************************/
 /*
  * get the ID of the specified process keyring
  * - the keyring must have search permission to be found
@@ -251,7 +246,6 @@ error:
 
 } /* end keyctl_get_keyring_ID() */
 
-/*****************************************************************************/
 /*
  * join the session keyring
  * - implements keyctl(KEYCTL_JOIN_SESSION_KEYRING)
@@ -277,10 +271,8 @@ long keyctl_join_session_keyring(const char __user *_name)
 
 error:
 	return ret;
+}
 
-} /* end keyctl_join_session_keyring() */
-
-/*****************************************************************************/
 /*
  * update a key's data payload
  * - the key must be writable
@@ -326,10 +318,8 @@ error2:
 	kfree(payload);
 error:
 	return ret;
+}
 
-} /* end keyctl_update_key() */
-
-/*****************************************************************************/
 /*
  * revoke a key
  * - the key must be writable
@@ -358,10 +348,8 @@ long keyctl_revoke_key(key_serial_t id)
 	key_ref_put(key_ref);
 error:
 	return ret;
+}
 
-} /* end keyctl_revoke_key() */
-
-/*****************************************************************************/
 /*
  * clear the specified process keyring
  * - the keyring must be writable
@@ -383,10 +371,8 @@ long keyctl_keyring_clear(key_serial_t ringid)
 	key_ref_put(keyring_ref);
 error:
 	return ret;
+}
 
-} /* end keyctl_keyring_clear() */
-
-/*****************************************************************************/
 /*
  * link a key into a keyring
  * - the keyring must be writable
@@ -417,10 +403,8 @@ error2:
 	key_ref_put(keyring_ref);
 error:
 	return ret;
+}
 
-} /* end keyctl_keyring_link() */
-
-/*****************************************************************************/
 /*
  * unlink the first attachment of a key from a keyring
  * - the keyring must be writable
@@ -451,10 +435,8 @@ error2:
 	key_ref_put(keyring_ref);
 error:
 	return ret;
+}
 
-} /* end keyctl_keyring_unlink() */
-
-/*****************************************************************************/
 /*
  * describe a user key
  * - the key must have view permission
@@ -531,10 +513,8 @@ error2:
 	key_ref_put(key_ref);
 error:
 	return ret;
+}
 
-} /* end keyctl_describe_key() */
-
-/*****************************************************************************/
 /*
  * search the specified keyring for a matching key
  * - the start keyring must be searchable
@@ -626,10 +606,8 @@ error2:
 	kfree(description);
 error:
 	return ret;
+}
 
-} /* end keyctl_keyring_search() */
-
-/*****************************************************************************/
 /*
  * read a user key's payload
  * - the keyring must be readable or the key must be searchable from the
@@ -688,10 +666,8 @@ error2:
 	key_put(key);
 error:
 	return ret;
+}
 
-} /* end keyctl_read_key() */
-
-/*****************************************************************************/
 /*
  * change the ownership of a key
  * - the keyring owned by the changer
@@ -796,10 +772,8 @@ quota_overrun:
 	zapowner = newowner;
 	ret = -EDQUOT;
 	goto error_put;
+}
 
-} /* end keyctl_chown_key() */
-
-/*****************************************************************************/
 /*
  * change the permission mask on a key
  * - the keyring owned by the changer
@@ -838,8 +812,7 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 	key_put(key);
 error:
 	return ret;
-
-} /* end keyctl_setperm_key() */
+}
 
 /*
  * get the destination keyring for instantiation
@@ -895,7 +868,6 @@ static int keyctl_change_reqkey_auth(struct key *key)
 	return commit_creds(new);
 }
 
-/*****************************************************************************/
 /*
  * instantiate the key with the specified payload, and, if one is given, link
  * the key into the keyring
@@ -973,10 +945,8 @@ error2:
 		vfree(payload);
 error:
 	return ret;
+}
 
-} /* end keyctl_instantiate_key() */
-
-/*****************************************************************************/
 /*
  * negatively instantiate the key with the given timeout (in seconds), and, if
  * one is given, link the key into the keyring
@@ -1020,10 +990,8 @@ long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 
 error:
 	return ret;
+}
 
-} /* end keyctl_negate_key() */
-
-/*****************************************************************************/
 /*
  * set the default keyring in which request_key() will cache keys
  * - return the old setting
@@ -1079,10 +1047,8 @@ set:
 error:
 	abort_creds(new);
 	return ret;
+}
 
-} /* end keyctl_set_reqkey_keyring() */
-
-/*****************************************************************************/
 /*
  * set or clear the timeout for a key
  */
@@ -1136,10 +1102,8 @@ okay:
 	ret = 0;
 error:
 	return ret;
+}
 
-} /* end keyctl_set_timeout() */
-
-/*****************************************************************************/
 /*
  * assume the authority to instantiate the specified key
  */
@@ -1178,8 +1142,7 @@ long keyctl_assume_authority(key_serial_t id)
 	ret = authkey->serial;
 error:
 	return ret;
-
-} /* end keyctl_assume_authority() */
+}
 
 /*
  * get the security label of a key
@@ -1348,7 +1311,6 @@ error_keyring:
 #endif /* !TIF_NOTIFY_RESUME */
 }
 
-/*****************************************************************************/
 /*
  * the key control system call
  */
@@ -1439,5 +1401,4 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	default:
 		return -EOPNOTSUPP;
 	}
-
-} /* end sys_keyctl() */
+}
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index d37f713..0a2b8e9 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -80,7 +80,6 @@ EXPORT_SYMBOL(key_type_keyring);
  */
 static DECLARE_RWSEM(keyring_serialise_link_sem);
 
-/*****************************************************************************/
 /*
  * publish the name of a keyring so that it can be found by name (if it has
  * one)
@@ -102,10 +101,8 @@ static void keyring_publish_name(struct key *keyring)
 
 		write_unlock(&keyring_name_lock);
 	}
+}
 
-} /* end keyring_publish_name() */
-
-/*****************************************************************************/
 /*
  * initialise a keyring
  * - we object if we were given any data
@@ -123,10 +120,8 @@ static int keyring_instantiate(struct key *keyring,
 	}
 
 	return ret;
+}
 
-} /* end keyring_instantiate() */
-
-/*****************************************************************************/
 /*
  * match keyrings on their name
  */
@@ -134,10 +129,8 @@ static int keyring_match(const struct key *keyring, const void *description)
 {
 	return keyring->description &&
 		strcmp(keyring->description, description) == 0;
+}
 
-} /* end keyring_match() */
-
-/*****************************************************************************/
 /*
  * dispose of the data dangling from the corpse of a keyring
  */
@@ -164,10 +157,8 @@ static void keyring_destroy(struct key *keyring)
 			key_put(klist->keys[loop]);
 		kfree(klist);
 	}
+}
 
-} /* end keyring_destroy() */
-
-/*****************************************************************************/
 /*
  * describe the keyring
  */
@@ -187,10 +178,8 @@ static void keyring_describe(const struct key *keyring, struct seq_file *m)
 	else
 		seq_puts(m, ": empty");
 	rcu_read_unlock();
+}
 
-} /* end keyring_describe() */
-
-/*****************************************************************************/
 /*
  * read a list of key IDs from the keyring's contents
  * - the keyring's semaphore is read-locked
@@ -241,10 +230,8 @@ static long keyring_read(const struct key *keyring,
 
 error:
 	return ret;
+}
 
-} /* end keyring_read() */
-
-/*****************************************************************************/
 /*
  * allocate a keyring and link into the destination keyring
  */
@@ -269,10 +256,8 @@ struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
 	}
 
 	return keyring;
+}
 
-} /* end keyring_alloc() */
-
-/*****************************************************************************/
 /*
  * search the supplied keyring tree for a key that matches the criterion
  * - perform a breadth-then-depth search up to the prescribed limit
@@ -444,10 +429,8 @@ error_2:
 	rcu_read_unlock();
 error:
 	return key_ref;
+}
 
-} /* end keyring_search_aux() */
-
-/*****************************************************************************/
 /*
  * search the supplied keyring tree for a key that matches the criterion
  * - perform a breadth-then-depth search up to the prescribed limit
@@ -465,12 +448,10 @@ key_ref_t keyring_search(key_ref_t keyring,
 
 	return keyring_search_aux(keyring, current->cred,
 				  type, description, type->match);
-
-} /* end keyring_search() */
+}
 
 EXPORT_SYMBOL(keyring_search);
 
-/*****************************************************************************/
 /*
  * search the given keyring only (no recursion)
  * - keyring must be locked by caller
@@ -514,10 +495,8 @@ found:
 	atomic_inc(&key->usage);
 	rcu_read_unlock();
 	return make_key_ref(key, possessed);
+}
 
-} /* end __keyring_search_one() */
-
-/*****************************************************************************/
 /*
  * find a keyring with the specified name
  * - all named keyrings are searched
@@ -569,10 +548,8 @@ struct key *find_keyring_by_name(const char *name, bool skip_perm_check)
 out:
 	read_unlock(&keyring_name_lock);
 	return keyring;
+}
 
-} /* end find_keyring_by_name() */
-
-/*****************************************************************************/
 /*
  * see if a cycle will will be created by inserting acyclic tree B in acyclic
  * tree A at the topmost level (ie: as a direct child of A)
@@ -657,8 +634,7 @@ too_deep:
 cycle_detected:
 	ret = -EDEADLK;
 	goto error;
-
-} /* end keyring_detect_cycle() */
+}
 
 /*
  * dispose of a keyring list after the RCU grace period, freeing the unlinked
@@ -898,7 +874,6 @@ int key_link(struct key *keyring, struct key *key)
 
 EXPORT_SYMBOL(key_link);
 
-/*****************************************************************************/
 /*
  * unlink the first link to a key from a keyring
  */
@@ -968,12 +943,10 @@ nomem:
 	ret = -ENOMEM;
 	up_write(&keyring->sem);
 	goto error;
-
-} /* end key_unlink() */
+}
 
 EXPORT_SYMBOL(key_unlink);
 
-/*****************************************************************************/
 /*
  * dispose of a keyring list after the RCU grace period, releasing the keys it
  * links to
@@ -989,10 +962,8 @@ static void keyring_clear_rcu_disposal(struct rcu_head *rcu)
 		key_put(klist->keys[loop]);
 
 	kfree(klist);
+}
 
-} /* end keyring_clear_rcu_disposal() */
-
-/*****************************************************************************/
 /*
  * clear the specified process keyring
  * - implements keyctl(KEYCTL_CLEAR)
@@ -1027,12 +998,10 @@ int keyring_clear(struct key *keyring)
 	}
 
 	return ret;
-
-} /* end keyring_clear() */
+}
 
 EXPORT_SYMBOL(keyring_clear);
 
-/*****************************************************************************/
 /*
  * dispose of the links from a revoked keyring
  * - called with the key sem write-locked
@@ -1050,8 +1019,7 @@ static void keyring_revoke(struct key *keyring)
 		rcu_assign_pointer(keyring->payload.subscriptions, NULL);
 		call_rcu(&klist->rcu, keyring_clear_rcu_disposal);
 	}
-
-} /* end keyring_revoke() */
+}
 
 /*
  * Determine whether a key is dead
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 2864550..6284b14 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -13,7 +13,6 @@
 #include <linux/security.h>
 #include "internal.h"
 
-/*****************************************************************************/
 /**
  * key_task_permission - Check a key can be used
  * @key_ref: The key to check
@@ -79,12 +78,10 @@ use_these_perms:
 
 	/* let LSM be the final arbiter */
 	return security_key_permission(key_ref, cred, perm);
-
-} /* end key_task_permission() */
+}
 
 EXPORT_SYMBOL(key_task_permission);
 
-/*****************************************************************************/
 /*
  * validate a key
  */
@@ -111,7 +108,6 @@ int key_validate(struct key *key)
 
 error:
 	return ret;
-
-} /* end key_validate() */
+}
 
 EXPORT_SYMBOL(key_validate);
diff --git a/security/keys/proc.c b/security/keys/proc.c
index 7037396..ad5f64e 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -60,7 +60,6 @@ static const struct file_operations proc_key_users_fops = {
 	.release	= seq_release,
 };
 
-/*****************************************************************************/
 /*
  * declare the /proc files
  */
@@ -79,12 +78,10 @@ static int __init key_proc_init(void)
 		panic("Cannot create /proc/key-users\n");
 
 	return 0;
-
-} /* end key_proc_init() */
+}
 
 __initcall(key_proc_init);
 
-/*****************************************************************************/
 /*
  * implement "/proc/keys" to provides a list of the keys on the system
  */
@@ -293,7 +290,6 @@ static struct rb_node *key_user_first(struct rb_root *r)
 	return __key_user_next(n);
 }
 
-/*****************************************************************************/
 /*
  * implement "/proc/key-users" to provides a list of the key users
  */
@@ -351,5 +347,4 @@ static int proc_key_users_show(struct seq_file *m, void *v)
 		   maxbytes);
 
 	return 0;
-
 }
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 504bdd2..ea55cf9 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -38,7 +38,6 @@ struct key_user root_key_user = {
 	.user_ns	= &init_user_ns,
 };
 
-/*****************************************************************************/
 /*
  * install user and user session keyrings for a particular UID
  */
@@ -275,7 +274,6 @@ static int install_session_keyring(struct key *keyring)
 	return commit_creds(new);
 }
 
-/*****************************************************************************/
 /*
  * the filesystem user ID changed
  */
@@ -288,10 +286,8 @@ void key_fsuid_changed(struct task_struct *tsk)
 		tsk->cred->thread_keyring->uid = tsk->cred->fsuid;
 		up_write(&tsk->cred->thread_keyring->sem);
 	}
+}
 
-} /* end key_fsuid_changed() */
-
-/*****************************************************************************/
 /*
  * the filesystem group ID changed
  */
@@ -304,10 +300,8 @@ void key_fsgid_changed(struct task_struct *tsk)
 		tsk->cred->thread_keyring->gid = tsk->cred->fsgid;
 		up_write(&tsk->cred->thread_keyring->sem);
 	}
+}
 
-} /* end key_fsgid_changed() */
-
-/*****************************************************************************/
 /*
  * search only my process keyrings for the first matching key
  * - we use the supplied match function to see if the description (or other
@@ -428,7 +422,6 @@ found:
 	return key_ref;
 }
 
-/*****************************************************************************/
 /*
  * search the process keyrings for the first matching key
  * - we use the supplied match function to see if the description (or other
@@ -489,20 +482,16 @@ key_ref_t search_process_keyrings(struct key_type *type,
 
 found:
 	return key_ref;
+}
 
-} /* end search_process_keyrings() */
-
-/*****************************************************************************/
 /*
  * see if the key we're looking at is the target key
  */
 int lookup_user_key_possessed(const struct key *key, const void *target)
 {
 	return key == target;
+}
 
-} /* end lookup_user_key_possessed() */
-
-/*****************************************************************************/
 /*
  * lookup a key given a key ID from userspace with a given permissions mask
  * - don't create special keyrings unless so requested
@@ -711,10 +700,8 @@ invalid_key:
 reget_creds:
 	put_cred(cred);
 	goto try_again;
+}
 
-} /* end lookup_user_key() */
-
-/*****************************************************************************/
 /*
  * join the named keyring as the session keyring if possible, or attempt to
  * create a new one of that name if not
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 8674715..ba717b8 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -38,7 +38,6 @@ struct key_type key_type_request_key_auth = {
 	.read		= request_key_auth_read,
 };
 
-/*****************************************************************************/
 /*
  * instantiate a request-key authorisation key
  */
@@ -48,10 +47,8 @@ static int request_key_auth_instantiate(struct key *key,
 {
 	key->payload.data = (struct request_key_auth *) data;
 	return 0;
+}
 
-} /* end request_key_auth_instantiate() */
-
-/*****************************************************************************/
 /*
  * reading a request-key authorisation key retrieves the callout information
  */
@@ -63,10 +60,8 @@ static void request_key_auth_describe(const struct key *key,
 	seq_puts(m, "key:");
 	seq_puts(m, key->description);
 	seq_printf(m, " pid:%d ci:%zu", rka->pid, rka->callout_len);
+}
 
-} /* end request_key_auth_describe() */
-
-/*****************************************************************************/
 /*
  * read the callout_info data
  * - the key's semaphore is read-locked
@@ -91,10 +86,8 @@ static long request_key_auth_read(const struct key *key,
 	}
 
 	return ret;
+}
 
-} /* end request_key_auth_read() */
-
-/*****************************************************************************/
 /*
  * handle revocation of an authorisation token key
  * - called with the key sem write-locked
@@ -109,10 +102,8 @@ static void request_key_auth_revoke(struct key *key)
 		put_cred(rka->cred);
 		rka->cred = NULL;
 	}
+}
 
-} /* end request_key_auth_revoke() */
-
-/*****************************************************************************/
 /*
  * destroy an instantiation authorisation token key
  */
@@ -131,10 +122,8 @@ static void request_key_auth_destroy(struct key *key)
 	key_put(rka->dest_keyring);
 	kfree(rka->callout_info);
 	kfree(rka);
+}
 
-} /* end request_key_auth_destroy() */
-
-/*****************************************************************************/
 /*
  * create an authorisation token for /sbin/request-key or whoever to gain
  * access to the caller's security data
@@ -228,10 +217,8 @@ error_alloc:
 	kfree(rka);
 	kleave("= %d", ret);
 	return ERR_PTR(ret);
+}
 
-} /* end request_key_auth_new() */
-
-/*****************************************************************************/
 /*
  * see if an authorisation key is associated with a particular key
  */
@@ -242,10 +229,8 @@ static int key_get_instantiation_authkey_match(const struct key *key,
 	key_serial_t id = (key_serial_t)(unsigned long) _id;
 
 	return rka->target_key->serial == id;
+}
 
-} /* end key_get_instantiation_authkey_match() */
-
-/*****************************************************************************/
 /*
  * get the authorisation key for instantiation of a specific key if attached to
  * the current process's keyrings
@@ -278,5 +263,4 @@ struct key *key_get_instantiation_authkey(key_serial_t target_id)
 
 error:
 	return authkey;
-
-} /* end key_get_instantiation_authkey() */
+}
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index e9aa079..02807fb 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -35,7 +35,6 @@ struct key_type key_type_user = {
 
 EXPORT_SYMBOL_GPL(key_type_user);
 
-/*****************************************************************************/
 /*
  * instantiate a user defined key
  */
@@ -65,12 +64,10 @@ int user_instantiate(struct key *key, const void *data, size_t datalen)
 
 error:
 	return ret;
-
-} /* end user_instantiate() */
+}
 
 EXPORT_SYMBOL_GPL(user_instantiate);
 
-/*****************************************************************************/
 /*
  * dispose of the old data from an updated user defined key
  */
@@ -81,10 +78,8 @@ static void user_update_rcu_disposal(struct rcu_head *rcu)
 	upayload = container_of(rcu, struct user_key_payload, rcu);
 
 	kfree(upayload);
+}
 
-} /* end user_update_rcu_disposal() */
-
-/*****************************************************************************/
 /*
  * update a user defined key
  * - the key's semaphore is write-locked
@@ -123,24 +118,20 @@ int user_update(struct key *key, const void *data, size_t datalen)
 
 error:
 	return ret;
-
-} /* end user_update() */
+}
 
 EXPORT_SYMBOL_GPL(user_update);
 
-/*****************************************************************************/
 /*
  * match users on their name
  */
 int user_match(const struct key *key, const void *description)
 {
 	return strcmp(key->description, description) == 0;
-
-} /* end user_match() */
+}
 
 EXPORT_SYMBOL_GPL(user_match);
 
-/*****************************************************************************/
 /*
  * dispose of the links from a revoked keyring
  * - called with the key sem write-locked
@@ -156,12 +147,10 @@ void user_revoke(struct key *key)
 		rcu_assign_pointer(key->payload.data, NULL);
 		call_rcu(&upayload->rcu, user_update_rcu_disposal);
 	}
-
-} /* end user_revoke() */
+}
 
 EXPORT_SYMBOL(user_revoke);
 
-/*****************************************************************************/
 /*
  * dispose of the data dangling from the corpse of a user key
  */
@@ -170,12 +159,10 @@ void user_destroy(struct key *key)
 	struct user_key_payload *upayload = key->payload.data;
 
 	kfree(upayload);
-
-} /* end user_destroy() */
+}
 
 EXPORT_SYMBOL_GPL(user_destroy);
 
-/*****************************************************************************/
 /*
  * describe the user key
  */
@@ -184,12 +171,10 @@ void user_describe(const struct key *key, struct seq_file *m)
 	seq_puts(m, key->description);
 
 	seq_printf(m, ": %u", key->datalen);
-
-} /* end user_describe() */
+}
 
 EXPORT_SYMBOL_GPL(user_describe);
 
-/*****************************************************************************/
 /*
  * read the key data
  * - the key's semaphore is read-locked
@@ -213,7 +198,6 @@ long user_read(const struct key *key, char __user *buffer, size_t buflen)
 	}
 
 	return ret;
-
-} /* end user_read() */
+}
 
 EXPORT_SYMBOL_GPL(user_read);

