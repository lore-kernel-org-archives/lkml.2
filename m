Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1ATQix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:38:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab1ATQiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:38:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] KEYS: Fix up comments in key management code
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Thu, 20 Jan 2011 16:38:33 +0000
Message-ID: <20110120163833.9797.56716.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110120163827.9797.35696.stgit@warthog.procyon.org.uk>
References: <20110120163827.9797.35696.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up comments in the key management code.  No functional changes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/compat.c           |   13 +-
 security/keys/gc.c               |   14 +-
 security/keys/internal.h         |   26 ++--
 security/keys/key.c              |  240 ++++++++++++++++++++++++---------
 security/keys/keyctl.c           |  278 +++++++++++++++++++++++++-------------
 security/keys/keyring.c          |  231 ++++++++++++++++++++++----------
 security/keys/permission.c       |   25 ++-
 security/keys/proc.c             |   10 +
 security/keys/process_keys.c     |  112 ++++++++++-----
 security/keys/request_key.c      |  164 +++++++++++++++++-----
 security/keys/request_key_auth.c |   30 ++--
 11 files changed, 777 insertions(+), 366 deletions(-)

diff --git a/security/keys/compat.c b/security/keys/compat.c
index 3cedf63..07a5f35 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -1,4 +1,4 @@
-/* compat.c: 32-bit compatibility syscall for 64-bit systems
+/* 32-bit compatibility syscall for 64-bit systems
  *
  * Copyright (C) 2004-5 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -15,11 +15,12 @@
 #include "internal.h"
 
 /*
- * the key control system call, 32-bit compatibility version for 64-bit archs
- * - this should only be called if the 64-bit arch uses weird pointers in
- *   32-bit mode or doesn't guarantee that the top 32-bits of the argument
- *   registers on taking a 32-bit syscall are zero
- * - if you can, you should call sys_keyctl directly
+ * The key control system call, 32-bit compatibility version for 64-bit archs
+ *
+ * This should only be called if the 64-bit arch uses weird pointers in 32-bit
+ * mode or doesn't guarantee that the top 32-bits of the argument registers on
+ * taking a 32-bit syscall are zero.  If you can, you should call sys_keyctl()
+ * directly.
  */
 asmlinkage long compat_sys_keyctl(u32 option,
 				  u32 arg2, u32 arg3, u32 arg4, u32 arg5)
diff --git a/security/keys/gc.c b/security/keys/gc.c
index a46e825..89df6b5 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -32,8 +32,8 @@ static time_t key_gc_next_run = LONG_MAX;
 static time_t key_gc_new_timer;
 
 /*
- * Schedule a garbage collection run
- * - precision isn't particularly important
+ * Schedule a garbage collection run.
+ * - time precision isn't particularly important
  */
 void key_schedule_gc(time_t gc_at)
 {
@@ -61,8 +61,9 @@ static void key_gc_timer_func(unsigned long data)
 }
 
 /*
- * Garbage collect pointers from a keyring
- * - return true if we altered the keyring
+ * Garbage collect pointers from a keyring.
+ *
+ * Return true if we altered the keyring.
  */
 static bool key_gc_keyring(struct key *keyring, time_t limit)
 	__releases(key_serial_lock)
@@ -107,9 +108,8 @@ do_gc:
 }
 
 /*
- * Garbage collector for keys
- * - this involves scanning the keyrings for dead, expired and revoked keys
- *   that have overstayed their welcome
+ * Garbage collector for keys.  This involves scanning the keyrings for dead,
+ * expired and revoked keys that have overstayed their welcome
  */
 static void key_garbage_collector(struct work_struct *work)
 {
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 56a133d..edfa50d 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -1,4 +1,4 @@
-/* internal.h: authentication token and access key management internal defs
+/* Authentication token and access key management internal defs
  *
  * Copyright (C) 2003-5, 2007 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -35,10 +35,12 @@ extern struct key_type key_type_user;
 
 /*****************************************************************************/
 /*
- * keep track of keys for a user
- * - this needs to be separate to user_struct to avoid a refcount-loop
- *   (user_struct pins some keyrings which pin this struct)
- * - this also keeps track of keys under request from userspace for this UID
+ * Keep track of keys for a user.
+ *
+ * This needs to be separate to user_struct to avoid a refcount-loop
+ * (user_struct pins some keyrings which pin this struct).
+ *
+ * We also keep track of keys under request from userspace for this UID here.
  */
 struct key_user {
 	struct rb_node		node;
@@ -62,7 +64,7 @@ extern struct key_user *key_user_lookup(uid_t uid,
 extern void key_user_put(struct key_user *user);
 
 /*
- * key quota limits
+ * Key quota limits.
  * - root has its own separate limits to everyone else
  */
 extern unsigned key_quota_root_maxkeys;
@@ -146,13 +148,13 @@ extern unsigned key_gc_delay;
 extern void keyring_gc(struct key *keyring, time_t limit);
 extern void key_schedule_gc(time_t expiry_at);
 
-/*
- * check to see whether permission is granted to use a key in the desired way
- */
 extern int key_task_permission(const key_ref_t key_ref,
 			       const struct cred *cred,
 			       key_perm_t perm);
 
+/*
+ * Check to see whether permission is granted to use a key in the desired way.
+ */
 static inline int key_permission(const key_ref_t key_ref, key_perm_t perm)
 {
 	return key_task_permission(key_ref, current_cred(), perm);
@@ -168,7 +170,7 @@ static inline int key_permission(const key_ref_t key_ref, key_perm_t perm)
 #define	KEY_ALL		0x3f	/* all the above permissions */
 
 /*
- * request_key authorisation
+ * Authorisation record for request_key().
  */
 struct request_key_auth {
 	struct key		*target_key;
@@ -188,7 +190,7 @@ extern struct key *request_key_auth_new(struct key *target,
 extern struct key *key_get_instantiation_authkey(key_serial_t target_id);
 
 /*
- * keyctl functions
+ * keyctl() functions
  */
 extern long keyctl_get_keyring_ID(key_serial_t, int);
 extern long keyctl_join_session_keyring(const char __user *);
@@ -214,7 +216,7 @@ extern long keyctl_get_security(key_serial_t keyid, char __user *buffer,
 extern long keyctl_session_to_parent(void);
 
 /*
- * debugging key validation
+ * Debugging key validation
  */
 #ifdef KEY_DEBUGGING
 extern void __key_check(const struct key *);
diff --git a/security/keys/key.c b/security/keys/key.c
index 3a92d73..84d4eb5 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -39,10 +39,10 @@ static DECLARE_RWSEM(key_types_sem);
 static void key_cleanup(struct work_struct *work);
 static DECLARE_WORK(key_cleanup_task, key_cleanup);
 
-/* we serialise key instantiation and link */
+/* We serialise key instantiation and link */
 DEFINE_MUTEX(key_construction_mutex);
 
-/* any key who's type gets unegistered will be re-typed to this */
+/* Any key who's type gets unegistered will be re-typed to this */
 static struct key_type key_type_dead = {
 	.name		= "dead",
 };
@@ -57,8 +57,8 @@ void __key_check(const struct key *key)
 #endif
 
 /*
- * get the key quota record for a user, allocating a new record if one doesn't
- * already exist
+ * Get the key quota record for a user, allocating a new record if one doesn't
+ * already exist.
  */
 struct key_user *key_user_lookup(uid_t uid, struct user_namespace *user_ns)
 {
@@ -66,7 +66,7 @@ struct key_user *key_user_lookup(uid_t uid, struct user_namespace *user_ns)
 	struct rb_node *parent = NULL;
 	struct rb_node **p;
 
- try_again:
+try_again:
 	p = &key_user_tree.rb_node;
 	spin_lock(&key_user_lock);
 
@@ -123,16 +123,16 @@ struct key_user *key_user_lookup(uid_t uid, struct user_namespace *user_ns)
 	goto out;
 
 	/* okay - we found a user record for this UID */
- found:
+found:
 	atomic_inc(&user->usage);
 	spin_unlock(&key_user_lock);
 	kfree(candidate);
- out:
+out:
 	return user;
 }
 
 /*
- * dispose of a user structure
+ * Dispose of a user structure
  */
 void key_user_put(struct key_user *user)
 {
@@ -146,9 +146,8 @@ void key_user_put(struct key_user *user)
 }
 
 /*
- * assign a key the next unique serial number
- * - these are assigned randomly to avoid security issues through covert
- *   channel problems
+ * Allocate a serial number for a key.  These are assigned randomly to avoid
+ * security issues through covert channel problems.
  */
 static inline void key_alloc_serial(struct key *key)
 {
@@ -208,14 +207,34 @@ serial_exists:
 	}
 }
 
-/*
- * allocate a key of the specified type
- * - update the user's quota to reflect the existence of the key
- * - called from a key-type operation with key_types_sem read-locked by
- *   key_create_or_update()
- *   - this prevents unregistration of the key type
- * - upon return the key is as yet uninstantiated; the caller needs to either
- *   instantiate the key or discard it before returning
+/**
+ * key_alloc - Allocate a key of the specified type.
+ * @type: The type of key to allocate.
+ * @desc: The key description to allow the key to be searched out.
+ * @uid: The owner of the new key.
+ * @gid: The group ID for the new key's group permissions.
+ * @cred: The credentials specifying UID namespace.
+ * @perm: The permissions mask of the new key.
+ * @flags: Flags specifying quota properties.
+ *
+ * Allocate a key of the specified type with the attributes given.  The key is
+ * returned in an uninstantiated state and the caller needs to instantiate the
+ * key before returning.
+ *
+ * The user's key count quota is updated to reflect the creation of the key and
+ * the user's key data quota has the default for the key type reserved.  The
+ * instantiation function should amend this as necessary.  If insufficient
+ * quota is available, -EDQUOT will be returned.
+ *
+ * The LSM security modules can prevent a key being created, in which case
+ * -EACCES will be returned.
+ *
+ * Returns a pointer to the new key if successful and an error code otherwise.
+ *
+ * Note that the caller needs to ensure the key type isn't uninstantiated.
+ * Internally this can be done by locking key_types_sem.  Externally, this can
+ * be done by either never unregistering the key type, or making sure
+ * key_alloc() calls don't race with module unloading.
  */
 struct key *key_alloc(struct key_type *type, const char *desc,
 		      uid_t uid, gid_t gid, const struct cred *cred,
@@ -338,11 +357,18 @@ no_quota:
 	key = ERR_PTR(-EDQUOT);
 	goto error;
 }
-
 EXPORT_SYMBOL(key_alloc);
 
-/*
- * reserve an amount of quota for the key's payload
+/**
+ * key_payload_reserve - Adjust data quota reservation for the key's payload
+ * @key: The key to make the reservation for.
+ * @datalen: The amount of data payload the caller now wants.
+ *
+ * Adjust the amount of the owning user's key data quota that a key reserves.
+ * If the amount is increased, then -EDQUOT may be returned if there isn't
+ * enough free quota available.
+ *
+ * If successful, 0 is returned.
  */
 int key_payload_reserve(struct key *key, size_t datalen)
 {
@@ -376,12 +402,13 @@ int key_payload_reserve(struct key *key, size_t datalen)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(key_payload_reserve);
 
 /*
- * instantiate a key and link it into the target keyring atomically
- * - called with the target keyring's semaphore writelocked
+ * Instantiate a key and link it into the target keyring atomically.  Must be
+ * called with the target keyring's semaphore writelocked.  The target key's
+ * semaphore need not be locked as instantiation is serialised by
+ * key_construction_mutex.
  */
 static int __key_instantiate_and_link(struct key *key,
 				      const void *data,
@@ -432,8 +459,21 @@ static int __key_instantiate_and_link(struct key *key,
 	return ret;
 }
 
-/*
- * instantiate a key and link it into the target keyring atomically
+/**
+ * key_instantiate_and_link - Instantiate a key and link it into the keyring.
+ * @key: The key to instantiate.
+ * @data: The data to use to instantiate the keyring.
+ * @datalen: The length of @data.
+ * @keyring: Keyring to create a link in on success (or NULL).
+ * @authkey: The authorisation token permitting instantiation.
+ *
+ * Instantiate a key that's in the uninstantiated state using the provided data
+ * and, if successful, link it in to the destination keyring if one is
+ * supplied.
+ *
+ * If successful, 0 is returned, the authorisation token is revoked and anyone
+ * waiting for the key is woken up.  If the key was already instantiated,
+ * -EBUSY will be returned.
  */
 int key_instantiate_and_link(struct key *key,
 			     const void *data,
@@ -462,8 +502,24 @@ int key_instantiate_and_link(struct key *key,
 
 EXPORT_SYMBOL(key_instantiate_and_link);
 
-/*
- * negatively instantiate a key and link it into the target keyring atomically
+/**
+ * key_negate_and_link - Negatively instantiate a key and link it into the keyring.
+ * @key: The key to instantiate.
+ * @timeout: The timeout on the negative key.
+ * @keyring: Keyring to create a link in on success (or NULL).
+ * @authkey: The authorisation token permitting instantiation.
+ *
+ * Negatively instantiate a key that's in the uninstantiated state and, if
+ * successful, set its timeout and link it in to the destination keyring if one
+ * is supplied.  The key and any links to the key will be automatically garbage
+ * collected after the timeout expires.
+ *
+ * Negative keys are used to rate limit repeated request_key() calls by causing
+ * them to return -ENOKEY until the negative key expires.
+ *
+ * If successful, 0 is returned, the authorisation token is revoked and anyone
+ * waiting for the key is woken up.  If the key was already instantiated,
+ * -EBUSY will be returned.
  */
 int key_negate_and_link(struct key *key,
 			unsigned timeout,
@@ -525,15 +581,18 @@ int key_negate_and_link(struct key *key,
 EXPORT_SYMBOL(key_negate_and_link);
 
 /*
- * do cleaning up in process context so that we don't have to disable
- * interrupts all over the place
+ * Garbage collect keys in process context so that we don't have to disable
+ * interrupts all over the place.
+ *
+ * key_put() schedules this rather than trying to do the cleanup itself, which
+ * means key_put() doesn't have to sleep.
  */
 static void key_cleanup(struct work_struct *work)
 {
 	struct rb_node *_n;
 	struct key *key;
 
- go_again:
+go_again:
 	/* look for a dead key in the tree */
 	spin_lock(&key_serial_lock);
 
@@ -547,7 +606,7 @@ static void key_cleanup(struct work_struct *work)
 	spin_unlock(&key_serial_lock);
 	return;
 
- found_dead_key:
+found_dead_key:
 	/* we found a dead key - once we've removed it from the tree, we can
 	 * drop the lock */
 	rb_erase(&key->serial_node, &key_serial_tree);
@@ -586,10 +645,13 @@ static void key_cleanup(struct work_struct *work)
 	goto go_again;
 }
 
-/*
- * dispose of a reference to a key
- * - when all the references are gone, we schedule the cleanup task to come and
- *   pull it out of the tree in definite process context
+/**
+ * key_put - Discard a reference to a key.
+ * @key: The key to discard a reference from.
+ *
+ * Discard a reference to a key, and when all the references are gone, we
+ * schedule the cleanup task to come and pull it out of the tree in process
+ * context at some later time.
  */
 void key_put(struct key *key)
 {
@@ -600,11 +662,10 @@ void key_put(struct key *key)
 			schedule_work(&key_cleanup_task);
 	}
 }
-
 EXPORT_SYMBOL(key_put);
 
 /*
- * find a key by its serial number
+ * Find a key by its serial number.
  */
 struct key *key_lookup(key_serial_t id)
 {
@@ -626,11 +687,11 @@ struct key *key_lookup(key_serial_t id)
 			goto found;
 	}
 
- not_found:
+not_found:
 	key = ERR_PTR(-ENOKEY);
 	goto error;
 
- found:
+found:
 	/* pretend it doesn't exist if it is awaiting deletion */
 	if (atomic_read(&key->usage) == 0)
 		goto not_found;
@@ -640,14 +701,16 @@ struct key *key_lookup(key_serial_t id)
 	 */
 	atomic_inc(&key->usage);
 
- error:
+error:
 	spin_unlock(&key_serial_lock);
 	return key;
 }
 
 /*
- * find and lock the specified key type against removal
- * - we return with the sem readlocked
+ * Find and lock the specified key type against removal.
+ *
+ * We return with the sem read-locked if successful.  If the type wasn't
+ * available -ENOKEY is returned instead.
  */
 struct key_type *key_type_lookup(const char *type)
 {
@@ -665,12 +728,12 @@ struct key_type *key_type_lookup(const char *type)
 	up_read(&key_types_sem);
 	ktype = ERR_PTR(-ENOKEY);
 
- found_kernel_type:
+found_kernel_type:
 	return ktype;
 }
 
 /*
- * unlock a key type
+ * Unlock a key type locked by key_type_lookup().
  */
 void key_type_put(struct key_type *ktype)
 {
@@ -678,9 +741,10 @@ void key_type_put(struct key_type *ktype)
 }
 
 /*
- * attempt to update an existing key
- * - the key has an incremented refcount
- * - we need to put the key if we get an error
+ * Attempt to update an existing key.
+ *
+ * The key is given to us with an incremented refcount that we need to discard
+ * if we get an error.
  */
 static inline key_ref_t __key_update(key_ref_t key_ref,
 				     const void *payload, size_t plen)
@@ -717,9 +781,30 @@ error:
 	goto out;
 }
 
-/*
- * search the specified keyring for a key of the same description; if one is
- * found, update it, otherwise add a new one
+/**
+ * key_create_or_update - Update or create and instantiate a key.
+ * @keyring_ref: A pointer to the destination keyring with possession flag.
+ * @type: The type of key.
+ * @description: The searchable description for the key.
+ * @payload: The data to use to instantiate or update the key.
+ * @plen: The length of @payload.
+ * @perm: The permissions mask for a new key.
+ * @flags: The quota flags for a new key.
+ *
+ * Search the destination keyring for a key of the same description and if one
+ * is found, update it, otherwise create and instantiate a new one and create a
+ * link to it from that keyring.
+ *
+ * If perm is KEY_PERM_UNDEF then an appropriate key permissions mask will be
+ * concocted.
+ *
+ * Returns a pointer to the new key if successful, -ENODEV if the key type
+ * wasn't available, -ENOTDIR if the keyring wasn't a keyring, -EACCES if the
+ * caller isn't permitted to modify the keyring or the LSM did not permit
+ * creation of the key.
+ *
+ * On success, the possession flag from the keyring ref will be tacked on to
+ * the key ref before it is returned.
  */
 key_ref_t key_create_or_update(key_ref_t keyring_ref,
 			       const char *type,
@@ -827,11 +912,20 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	key_ref = __key_update(key_ref, payload, plen);
 	goto error;
 }
-
 EXPORT_SYMBOL(key_create_or_update);
 
-/*
- * update a key
+/**
+ * key_update - Update a key's contents.
+ * @key_ref: The pointer (plus possession flag) to the key.
+ * @payload: The data to be used to update the key.
+ * @plen: The length of @payload.
+ *
+ * Attempt to update the contents of a key with the given payload data.  The
+ * caller must be granted Write permission on the key.  Negative keys can be
+ * instantiated by this method.
+ *
+ * Returns 0 on success, -EACCES if not permitted and -EOPNOTSUPP if the key
+ * type does not support updating.  The key type may return other errors.
  */
 int key_update(key_ref_t key_ref, const void *payload, size_t plen)
 {
@@ -861,11 +955,16 @@ int key_update(key_ref_t key_ref, const void *payload, size_t plen)
  error:
 	return ret;
 }
-
 EXPORT_SYMBOL(key_update);
 
-/*
- * revoke a key
+/**
+ * key_revoke - Revoke a key.
+ * @key: The key to be revoked.
+ *
+ * Mark a key as being revoked and ask the type to free up its resources.  The
+ * revocation timeout is set and the key and all its links will be
+ * automatically garbage collected after key_gc_delay amount of time if they
+ * are not manually dealt with first.
  */
 void key_revoke(struct key *key)
 {
@@ -894,11 +993,15 @@ void key_revoke(struct key *key)
 
 	up_write(&key->sem);
 }
-
 EXPORT_SYMBOL(key_revoke);
 
-/*
- * register a type of key
+/**
+ * register_key_type - Register a type of key.
+ * @ktype: The new key type.
+ *
+ * Register a new key type.
+ *
+ * Returns 0 on success or -EEXIST if a type of this name already exists.
  */
 int register_key_type(struct key_type *ktype)
 {
@@ -918,15 +1021,19 @@ int register_key_type(struct key_type *ktype)
 	list_add(&ktype->link, &key_types_list);
 	ret = 0;
 
- out:
+out:
 	up_write(&key_types_sem);
 	return ret;
 }
-
 EXPORT_SYMBOL(register_key_type);
 
-/*
- * unregister a type of key
+/**
+ * unregister_key_type - Unregister a type of key.
+ * @ktype: The key type.
+ *
+ * Unregister a key type and mark all the extant keys of this type as dead.
+ * Those keys of this type are then destroyed to get rid of their payloads and
+ * they and their links will be garbage collected as soon as possible.
  */
 void unregister_key_type(struct key_type *ktype)
 {
@@ -974,11 +1081,10 @@ void unregister_key_type(struct key_type *ktype)
 
 	key_schedule_gc(0);
 }
-
 EXPORT_SYMBOL(unregister_key_type);
 
 /*
- * initialise the key management stuff
+ * Initialise the key management state.
  */
 void __init key_init(void)
 {
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 83ec98b7..31a0fd8 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1,4 +1,4 @@
-/* keyctl.c: userspace keyctl operations
+/* Userspace key control operations
  *
  * Copyright (C) 2004-5 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -31,27 +31,24 @@ static int key_get_type_from_user(char *type,
 	int ret;
 
 	ret = strncpy_from_user(type, _type, len);
-
 	if (ret < 0)
 		return ret;
-
 	if (ret == 0 || ret >= len)
 		return -EINVAL;
-
 	if (type[0] == '.')
 		return -EPERM;
-
 	type[len - 1] = '\0';
-
 	return 0;
 }
 
 /*
- * extract the description of a new key from userspace and either add it as a
- * new key to the specified keyring or update a matching key in that keyring
- * - the keyring must be writable
- * - returns the new key's serial number
- * - implements add_key()
+ * Extract the description of a new key from userspace and either add it as a
+ * new key to the specified keyring or update a matching key in that keyring.
+ *
+ * The keyring must be writable so that we can attach the key to it.
+ *
+ * If successful, the new key's serial number is returned, otherwise an error
+ * code is returned.
  */
 SYSCALL_DEFINE5(add_key, const char __user *, _type,
 		const char __user *, _description,
@@ -134,14 +131,17 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 }
 
 /*
- * search the process keyrings for a matching key
- * - nested keyrings may also be searched if they have Search permission
- * - if a key is found, it will be attached to the destination keyring if
- *   there's one specified
- * - /sbin/request-key will be invoked if _callout_info is non-NULL
- *   - the _callout_info string will be passed to /sbin/request-key
- *   - if the _callout_info string is empty, it will be rendered as "-"
- * - implements request_key()
+ * Search the process keyrings and keyring trees linked from those for a
+ * matching key.  Keyrings must have appropriate Search permission to be
+ * searched.
+ *
+ * If a key is found, it will be attached to the destination keyring if there's
+ * one specified and the serial number of the key will be returned.
+ *
+ * If no key is found, /sbin/request-key will be invoked if _callout_info is
+ * non-NULL in an attempt to create a key.  The _callout_info string will be
+ * passed to /sbin/request-key to aid with completing the request.  If the
+ * _callout_info string is "" then it will be changed to "-".
  */
 SYSCALL_DEFINE4(request_key, const char __user *, _type,
 		const char __user *, _description,
@@ -222,9 +222,11 @@ error:
 }
 
 /*
- * get the ID of the specified process keyring
- * - the keyring must have search permission to be found
- * - implements keyctl(KEYCTL_GET_KEYRING_ID)
+ * Get the ID of the specified process keyring.
+ *
+ * The requested keyring must have search permission to be found.
+ *
+ * If successful, the ID of the requested keyring will be returned.
  */
 long keyctl_get_keyring_ID(key_serial_t id, int create)
 {
@@ -243,12 +245,17 @@ long keyctl_get_keyring_ID(key_serial_t id, int create)
 	key_ref_put(key_ref);
 error:
 	return ret;
-
-} /* end keyctl_get_keyring_ID() */
+}
 
 /*
- * join the session keyring
- * - implements keyctl(KEYCTL_JOIN_SESSION_KEYRING)
+ * Join a (named) session keyring.
+ *
+ * Create and join an anonymous session keyring or join a named session
+ * keyring, creating it if necessary.  A named session keyring must have Search
+ * permission for it to be joined.  Session keyrings without this permit will
+ * be skipped over.
+ *
+ * If successful, the ID of the joined session keyring will be returned.
  */
 long keyctl_join_session_keyring(const char __user *_name)
 {
@@ -274,9 +281,14 @@ error:
 }
 
 /*
- * update a key's data payload
- * - the key must be writable
- * - implements keyctl(KEYCTL_UPDATE)
+ * Update a key's data payload from the given data.
+ *
+ * The key must grant the caller Write permission and the key type must support
+ * updating for this to work.  A negative key can be positively instantiated
+ * with this call.
+ *
+ * If successful, 0 will be returned.  If the key type does not support
+ * updating, then -EOPNOTSUPP will be returned.
  */
 long keyctl_update_key(key_serial_t id,
 		       const void __user *_payload,
@@ -321,9 +333,14 @@ error:
 }
 
 /*
- * revoke a key
- * - the key must be writable
- * - implements keyctl(KEYCTL_REVOKE)
+ * Revoke a key.
+ *
+ * The key must be grant the caller Write or Setattr permission for this to
+ * work.  The key type should give up its quota claim when revoked.  The key
+ * and any links to the key will be automatically garbage collected after a
+ * certain amount of time (/proc/sys/kernel/keys/gc_delay).
+ *
+ * If successful, 0 is returned.
  */
 long keyctl_revoke_key(key_serial_t id)
 {
@@ -351,9 +368,11 @@ error:
 }
 
 /*
- * clear the specified process keyring
- * - the keyring must be writable
- * - implements keyctl(KEYCTL_CLEAR)
+ * Clear the specified keyring, creating an empty process keyring if one of the
+ * special keyring IDs is used.
+ *
+ * The keyring must grant the caller Write permission for this to work.  If
+ * successful, 0 will be returned.
  */
 long keyctl_keyring_clear(key_serial_t ringid)
 {
@@ -374,10 +393,15 @@ error:
 }
 
 /*
- * link a key into a keyring
- * - the keyring must be writable
- * - the key must be linkable
- * - implements keyctl(KEYCTL_LINK)
+ * Create a link from a keyring to a key if there's no matching key in the
+ * keyring, otherwise replace the link to the matching key with a link to the
+ * new key.
+ *
+ * The key must grant the caller Link permission and the the keyring must grant
+ * the caller Write permission.  Furthermore, if an additional link is created,
+ * the keyring's quota will be extended.
+ *
+ * If successful, 0 will be returned.
  */
 long keyctl_keyring_link(key_serial_t id, key_serial_t ringid)
 {
@@ -406,10 +430,13 @@ error:
 }
 
 /*
- * unlink the first attachment of a key from a keyring
- * - the keyring must be writable
- * - we don't need any permissions on the key
- * - implements keyctl(KEYCTL_UNLINK)
+ * Unlink a key from a keyring.
+ *
+ * The keyring must grant the caller Write permission for this to work; the key
+ * itself need not grant the caller anything.  If the last link to a key is
+ * removed then that key will be scheduled for destruction.
+ *
+ * If successful, 0 will be returned.
  */
 long keyctl_keyring_unlink(key_serial_t id, key_serial_t ringid)
 {
@@ -438,14 +465,17 @@ error:
 }
 
 /*
- * describe a user key
- * - the key must have view permission
- * - if there's a buffer, we place up to buflen bytes of data into it
- * - unless there's an error, we return the amount of description available,
- *   irrespective of how much we may have copied
- * - the description is formatted thus:
+ * Return a description of a key to userspace.
+ *
+ * The key must grant the caller View permission for this to work.
+ *
+ * If there's a buffer, we place up to buflen bytes of data into it formatted
+ * in the following way:
+ *
  *	type;uid;gid;perm;description<NUL>
- * - implements keyctl(KEYCTL_DESCRIBE)
+ *
+ * If successful, we return the amount of description available, irrespective
+ * of how much we may have copied into the buffer.
  */
 long keyctl_describe_key(key_serial_t keyid,
 			 char __user *buffer,
@@ -516,13 +546,14 @@ error:
 }
 
 /*
- * search the specified keyring for a matching key
- * - the start keyring must be searchable
- * - nested keyrings may also be searched if they are searchable
- * - only keys with search permission may be found
- * - if a key is found, it will be attached to the destination keyring if
- *   there's one specified
- * - implements keyctl(KEYCTL_SEARCH)
+ * Search the specified keyring and any keyrings it links to for a matching
+ * key.  Only keyrings that grant the caller Search permission will be searched
+ * (this includes the starting keyring).  Only keys with Search permission can
+ * be found.
+ *
+ * If successful, the found key will be linked to the destination keyring if
+ * supplied and the key has Link permission, and the found key ID will be
+ * returned.
  */
 long keyctl_keyring_search(key_serial_t ringid,
 			   const char __user *_type,
@@ -609,13 +640,14 @@ error:
 }
 
 /*
- * read a user key's payload
- * - the keyring must be readable or the key must be searchable from the
- *   process's keyrings
- * - if there's a buffer, we place up to buflen bytes of data into it
- * - unless there's an error, we return the amount of data in the key,
- *   irrespective of how much we may have copied
- * - implements keyctl(KEYCTL_READ)
+ * Read a key's payload.
+ *
+ * The key must either grant the caller Read permission, or it must grant the
+ * caller Search permission when searched for from the process keyrings.
+ *
+ * If successful, we place up to buflen bytes of data into the buffer, if one
+ * is provided, and return the amount of data that is available in the key,
+ * irrespective of how much we copied into the buffer.
  */
 long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 {
@@ -669,10 +701,19 @@ error:
 }
 
 /*
- * change the ownership of a key
- * - the keyring owned by the changer
- * - if the uid or gid is -1, then that parameter is not changed
- * - implements keyctl(KEYCTL_CHOWN)
+ * Change the ownership of a key
+ *
+ * The key must grant the caller Setattr permission for this to work, though
+ * the key need not be fully instantiated yet.  For the UID to be changed, or
+ * for the GID to be changed to a group the caller is not a member of, the
+ * caller must have sysadmin capability.  If either uid or gid is -1 then that
+ * attribute is not changed.
+ *
+ * If the UID is to be changed, the new user must have sufficient quota to
+ * accept the key.  The quota deduction will be removed from the old user to
+ * the new user should the attribute be changed.
+ *
+ * If successful, 0 will be returned.
  */
 long keyctl_chown_key(key_serial_t id, uid_t uid, gid_t gid)
 {
@@ -775,9 +816,11 @@ quota_overrun:
 }
 
 /*
- * change the permission mask on a key
- * - the keyring owned by the changer
- * - implements keyctl(KEYCTL_SETPERM)
+ * Change the permission mask on a key.
+ *
+ * The key must grant the caller Setattr permission for this to work, though
+ * the key need not be fully instantiated yet.  If the caller does not have
+ * sysadmin capability, it may only change the permission on keys that it owns.
  */
 long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 {
@@ -815,7 +858,8 @@ error:
 }
 
 /*
- * get the destination keyring for instantiation
+ * Get the destination keyring for instantiation and check that the caller has
+ * Write permission on it.
  */
 static long get_instantiation_keyring(key_serial_t ringid,
 				      struct request_key_auth *rka,
@@ -852,7 +896,7 @@ static long get_instantiation_keyring(key_serial_t ringid,
 }
 
 /*
- * change the request_key authorisation key on the current process
+ * Change the request_key authorisation key on the current process.
  */
 static int keyctl_change_reqkey_auth(struct key *key)
 {
@@ -869,8 +913,13 @@ static int keyctl_change_reqkey_auth(struct key *key)
 }
 
 /*
- * instantiate the key with the specified payload, and, if one is given, link
- * the key into the keyring
+ * Instantiate a key with the specified payload and link the key into the
+ * destination keyring if one is given.
+ *
+ * The caller must have the appropriate instantiation permit set for this to
+ * work (see keyctl_assume_authority).  No other permissions are required.
+ *
+ * If successful, 0 will be returned.
  */
 long keyctl_instantiate_key(key_serial_t id,
 			    const void __user *_payload,
@@ -948,8 +997,19 @@ error:
 }
 
 /*
- * negatively instantiate the key with the given timeout (in seconds), and, if
- * one is given, link the key into the keyring
+ * Negatively instantiate the key with the given timeout (in seconds) and link
+ * the key into the destination keyring if one is given.
+ *
+ * The caller must have the appropriate instantiation permit set for this to
+ * work (see keyctl_assume_authority).  No other permissions are required.
+ *
+ * The key and any links to the key will be automatically garbage collected
+ * after the timeout expires.
+ *
+ * Negative keys are used to rate limit repeated request_key() calls by causing
+ * them to return -ENOKEY until the negative key expires.
+ *
+ * If successful, 0 will be returned.
  */
 long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 {
@@ -993,8 +1053,11 @@ error:
 }
 
 /*
- * set the default keyring in which request_key() will cache keys
- * - return the old setting
+ * Read or set the default keyring in which request_key() will cache keys and
+ * return the old setting.
+ *
+ * If a process keyring is specified then this will be created if it doesn't
+ * yet exist.  The old setting will be returned if successful.
  */
 long keyctl_set_reqkey_keyring(int reqkey_defl)
 {
@@ -1050,7 +1113,16 @@ error:
 }
 
 /*
- * set or clear the timeout for a key
+ * Set or clear the timeout on a key.
+ *
+ * Either the key must grant the caller Setattr permission or else the caller
+ * must hold an instantiation authorisation token for the key.
+ *
+ * The timeout is either 0 to clear the timeout, or a number of seconds from
+ * the current time.  The key and any links to the key will be automatically
+ * garbage collected after the timeout expires.
+ *
+ * If successful, 0 is returned.
  */
 long keyctl_set_timeout(key_serial_t id, unsigned timeout)
 {
@@ -1105,7 +1177,21 @@ error:
 }
 
 /*
- * assume the authority to instantiate the specified key
+ * Assume (or clear) the authority to instantiate the specified key.
+ *
+ * This sets the authoritative token currently in force for key instantiation.
+ * This must be done for a key to be instantiated.  It has the effect of making
+ * available all the keys from the caller of the request_key() that created a
+ * key to request_key() calls made by the caller of this function.
+ *
+ * The caller must have the instantiation key in their process keyrings with a
+ * Search permission grant available to the caller.
+ *
+ * If the ID given is 0, then the setting will be cleared and 0 returned.
+ *
+ * If the ID given has a matching an authorisation key, then that key will be
+ * set and its ID will be returned.  The authorisation key can be read to get
+ * the callout information passed to request_key().
  */
 long keyctl_assume_authority(key_serial_t id)
 {
@@ -1145,12 +1231,14 @@ error:
 }
 
 /*
- * get the security label of a key
- * - the key must grant us view permission
- * - if there's a buffer, we place up to buflen bytes of data into it
- * - unless there's an error, we return the amount of information available,
- *   irrespective of how much we may have copied (including the terminal NUL)
- * - implements keyctl(KEYCTL_GET_SECURITY)
+ * Get a key's the LSM security label.
+ *
+ * The key must grant the caller View permission for this to work.
+ *
+ * If there's a buffer, then up to buflen bytes of data will be placed into it.
+ *
+ * If successful, the amount of information available will be returned,
+ * irrespective of how much was copied (including the terminal NUL).
  */
 long keyctl_get_security(key_serial_t keyid,
 			 char __user *buffer,
@@ -1205,10 +1293,16 @@ long keyctl_get_security(key_serial_t keyid,
 }
 
 /*
- * attempt to install the calling process's session keyring on the process's
- * parent process
- * - the keyring must exist and must grant us LINK permission
- * - implements keyctl(KEYCTL_SESSION_TO_PARENT)
+ * Attempt to install the calling process's session keyring on the process's
+ * parent process.
+ *
+ * The keyring must exist and must grant the caller LINK permission, and the
+ * parent process must be single-threaded and must have the same effective
+ * ownership as this process and mustn't be SUID/SGID.
+ *
+ * The keyring will be emplaced on the parent when it next resumes userspace.
+ *
+ * If successful, 0 will be returned.
  */
 long keyctl_session_to_parent(void)
 {
@@ -1312,7 +1406,7 @@ error_keyring:
 }
 
 /*
- * the key control system call
+ * The key control system call
  */
 SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 0a2b8e9..92024ed 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -26,13 +26,13 @@
 		rwsem_is_locked((struct rw_semaphore *)&(keyring)->sem)))
 
 /*
- * when plumbing the depths of the key tree, this sets a hard limit set on how
- * deep we're willing to go
+ * When plumbing the depths of the key tree, this sets a hard limit
+ * set on how deep we're willing to go.
  */
 #define KEYRING_SEARCH_MAX_DEPTH 6
 
 /*
- * we keep all named keyrings in a hash to speed looking them up
+ * We keep all named keyrings in a hash to speed looking them up.
  */
 #define KEYRING_NAME_HASH_SIZE	(1 << 5)
 
@@ -50,7 +50,9 @@ static inline unsigned keyring_hash(const char *desc)
 }
 
 /*
- * the keyring type definition
+ * The keyring key type definition.  Keyrings are simply keys of this type and
+ * can be treated as ordinary keys in addition to having their own special
+ * operations.
  */
 static int keyring_instantiate(struct key *keyring,
 			       const void *data, size_t datalen);
@@ -71,18 +73,17 @@ struct key_type key_type_keyring = {
 	.describe	= keyring_describe,
 	.read		= keyring_read,
 };
-
 EXPORT_SYMBOL(key_type_keyring);
 
 /*
- * semaphore to serialise link/link calls to prevent two link calls in parallel
- * introducing a cycle
+ * Semaphore to serialise link/link calls to prevent two link calls in parallel
+ * introducing a cycle.
  */
 static DECLARE_RWSEM(keyring_serialise_link_sem);
 
 /*
- * publish the name of a keyring so that it can be found by name (if it has
- * one)
+ * Publish the name of a keyring so that it can be found by name (if it has
+ * one).
  */
 static void keyring_publish_name(struct key *keyring)
 {
@@ -104,8 +105,9 @@ static void keyring_publish_name(struct key *keyring)
 }
 
 /*
- * initialise a keyring
- * - we object if we were given any data
+ * Initialise a keyring.
+ *
+ * Returns 0 on success, -EINVAL if given any data.
  */
 static int keyring_instantiate(struct key *keyring,
 			       const void *data, size_t datalen)
@@ -123,7 +125,7 @@ static int keyring_instantiate(struct key *keyring,
 }
 
 /*
- * match keyrings on their name
+ * Match keyrings on their name
  */
 static int keyring_match(const struct key *keyring, const void *description)
 {
@@ -132,7 +134,8 @@ static int keyring_match(const struct key *keyring, const void *description)
 }
 
 /*
- * dispose of the data dangling from the corpse of a keyring
+ * Clean up a keyring when it is destroyed.  Unpublish its name if it had one
+ * and dispose of its data.
  */
 static void keyring_destroy(struct key *keyring)
 {
@@ -160,7 +163,7 @@ static void keyring_destroy(struct key *keyring)
 }
 
 /*
- * describe the keyring
+ * Describe a keyring for /proc.
  */
 static void keyring_describe(const struct key *keyring, struct seq_file *m)
 {
@@ -181,8 +184,9 @@ static void keyring_describe(const struct key *keyring, struct seq_file *m)
 }
 
 /*
- * read a list of key IDs from the keyring's contents
- * - the keyring's semaphore is read-locked
+ * Read a list of key IDs from the keyring's contents in binary form
+ *
+ * The keyring's semaphore is read-locked by the caller.
  */
 static long keyring_read(const struct key *keyring,
 			 char __user *buffer, size_t buflen)
@@ -233,7 +237,7 @@ error:
 }
 
 /*
- * allocate a keyring and link into the destination keyring
+ * Allocate a keyring and link into the destination keyring.
  */
 struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
 			  const struct cred *cred, unsigned long flags,
@@ -258,16 +262,40 @@ struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
 	return keyring;
 }
 
-/*
- * search the supplied keyring tree for a key that matches the criterion
- * - perform a breadth-then-depth search up to the prescribed limit
- * - we only find keys on which we have search permission
- * - we use the supplied match function to see if the description (or other
- *   feature of interest) matches
- * - we rely on RCU to prevent the keyring lists from disappearing on us
- * - we return -EAGAIN if we didn't find any matching key
- * - we return -ENOKEY if we only found negative matching keys
- * - we propagate the possession attribute from the keyring ref to the key ref
+/**
+ * keyring_search_aux - Search a keyring tree for a key matching some criteria
+ * @keyring_ref: A pointer to the keyring with possession indicator.
+ * @cred: The credentials to use for permissions checks.
+ * @type: The type of key to search for.
+ * @description: Parameter for @match.
+ * @match: Function to rule on whether or not a key is the one required.
+ *
+ * Search the supplied keyring tree for a key that matches the criteria given.
+ * The root keyring and any linked keyrings must grant Search permission to the
+ * caller to be searchable and keys can only be found if they too grant Search
+ * to the caller. The possession flag on the root keyring pointer controls use
+ * of the possessor bits in permissions checking of the entire tree.  In
+ * addition, the LSM gets to forbid keyring searches and key matches.
+ *
+ * The search is performed as a breadth-then-depth search up to the prescribed
+ * limit (KEYRING_SEARCH_MAX_DEPTH).
+ *
+ * Keys are matched to the type provided and are then filtered by the match
+ * function, which is given the description to use in any way it sees fit.  The
+ * match function may use any attributes of a key that it wishes to to
+ * determine the match.  Normally the match function from the key type would be
+ * used.
+ *
+ * RCU is used to prevent the keyring key lists from disappearing without the
+ * need to take lots of locks.
+ *
+ * Returns a pointer to the found key and increments the key usage count if
+ * successful; -EAGAIN if no matching keys were found, or if expired or revoked
+ * keys were found; -ENOKEY if only negative keys were found; -ENOTDIR if the
+ * specified keyring wasn't a keyring.
+ *
+ * In the case of a successful return, the possession attribute from
+ * @keyring_ref is propagated to the returned key reference.
  */
 key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 			     const struct cred *cred,
@@ -431,13 +459,14 @@ error:
 	return key_ref;
 }
 
-/*
- * search the supplied keyring tree for a key that matches the criterion
- * - perform a breadth-then-depth search up to the prescribed limit
- * - we only find keys on which we have search permission
- * - we readlock the keyrings as we search down the tree
- * - we return -EAGAIN if we didn't find any matching key
- * - we return -ENOKEY if we only found negative matching keys
+/**
+ * keyring_search - Search the supplied keyring tree for a matching key
+ * @keyring: The root of the keyring tree to be searched.
+ * @type: The type of keyring we want to find.
+ * @description: The name of the keyring we want to find.
+ *
+ * As keyring_search_aux() above, but using the current task's credentials and
+ * type's default matching function.
  */
 key_ref_t keyring_search(key_ref_t keyring,
 			 struct key_type *type,
@@ -449,13 +478,22 @@ key_ref_t keyring_search(key_ref_t keyring,
 	return keyring_search_aux(keyring, current->cred,
 				  type, description, type->match);
 }
-
 EXPORT_SYMBOL(keyring_search);
 
 /*
- * search the given keyring only (no recursion)
- * - keyring must be locked by caller
- * - caller must guarantee that the keyring is a keyring
+ * Search the given keyring only (no recursion).
+ *
+ * The caller must guarantee that the keyring is a keyring and that the
+ * permission is granted to search the keyring as no check is made here.
+ *
+ * RCU is used to make it unnecessary to lock the keyring key list here.
+ *
+ * Returns a pointer to the found key with usage count incremented if
+ * successful and returns -ENOKEY if not found.  Revoked keys and keys not
+ * providing the requested permission are skipped over.
+ *
+ * If successful, the possession indicator is propagated from the keyring ref
+ * to the returned key reference.
  */
 key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 			       const struct key_type *ktype,
@@ -498,9 +536,15 @@ found:
 }
 
 /*
- * find a keyring with the specified name
- * - all named keyrings are searched
- * - normally only finds keyrings with search permission for the current process
+ * Find a keyring with the specified name.
+ *
+ * All named keyrings in the current user namespace are searched, provided they
+ * grant Search permission directly to the caller (unless this check is
+ * skipped).  Keyrings whose usage points have reached zero or who have been
+ * revoked are skipped.
+ *
+ * Returns a pointer to the keyring with the keyring's refcount having being
+ * incremented on success.  -ENOKEY is returned if a key could not be found.
  */
 struct key *find_keyring_by_name(const char *name, bool skip_perm_check)
 {
@@ -551,10 +595,11 @@ out:
 }
 
 /*
- * see if a cycle will will be created by inserting acyclic tree B in acyclic
- * tree A at the topmost level (ie: as a direct child of A)
- * - since we are adding B to A at the top level, checking for cycles should
- *   just be a matter of seeing if node A is somewhere in tree B
+ * See if a cycle will will be created by inserting acyclic tree B in acyclic
+ * tree A at the topmost level (ie: as a direct child of A).
+ *
+ * Since we are adding B to A at the top level, checking for cycles should just
+ * be a matter of seeing if node A is somewhere in tree B.
  */
 static int keyring_detect_cycle(struct key *A, struct key *B)
 {
@@ -637,7 +682,7 @@ cycle_detected:
 }
 
 /*
- * dispose of a keyring list after the RCU grace period, freeing the unlinked
+ * Dispose of a keyring list after the RCU grace period, freeing the unlinked
  * key
  */
 static void keyring_unlink_rcu_disposal(struct rcu_head *rcu)
@@ -651,7 +696,7 @@ static void keyring_unlink_rcu_disposal(struct rcu_head *rcu)
 }
 
 /*
- * preallocate memory so that a key can be linked into to a keyring
+ * Preallocate memory so that a key can be linked into to a keyring.
  */
 int __key_link_begin(struct key *keyring, const struct key_type *type,
 		     const char *description,
@@ -768,10 +813,10 @@ error_krsem:
 }
 
 /*
- * check already instantiated keys aren't going to be a problem
- * - the caller must have called __key_link_begin()
- * - don't need to call this for keys that were created since __key_link_begin()
- *   was called
+ * Check already instantiated keys aren't going to be a problem.
+ *
+ * The caller must have called __key_link_begin(). Don't need to call this for
+ * keys that were created since __key_link_begin() was called.
  */
 int __key_link_check_live_key(struct key *keyring, struct key *key)
 {
@@ -783,9 +828,12 @@ int __key_link_check_live_key(struct key *keyring, struct key *key)
 }
 
 /*
- * link a key into to a keyring
- * - must be called with __key_link_begin() having being called
- * - discard already extant link to matching key if there is one
+ * Link a key into to a keyring.
+ *
+ * Must be called with __key_link_begin() having being called.  Discards any
+ * already extant link to matching key if there is one, so that each keyring
+ * holds at most one link to any given key of a particular type+description
+ * combination.
  */
 void __key_link(struct key *keyring, struct key *key,
 		struct keyring_list **_prealloc)
@@ -828,8 +876,9 @@ void __key_link(struct key *keyring, struct key *key,
 }
 
 /*
- * finish linking a key into to a keyring
- * - must be called with __key_link_begin() having being called
+ * Finish linking a key into to a keyring.
+ *
+ * Must be called with __key_link_begin() having being called.
  */
 void __key_link_end(struct key *keyring, struct key_type *type,
 		    struct keyring_list *prealloc)
@@ -850,8 +899,25 @@ void __key_link_end(struct key *keyring, struct key_type *type,
 	up_write(&keyring->sem);
 }
 
-/*
- * link a key to a keyring
+/**
+ * key_link - Link a key to a keyring
+ * @keyring: The keyring to make the link in.
+ * @key: The key to link to.
+ *
+ * Make a link in a keyring to a key, such that the keyring holds a reference
+ * on that key and the key can potentially be found by searching that keyring.
+ *
+ * This function will write-lock the keyring's semaphore and will consume some
+ * of the user's key data quota to hold the link.
+ *
+ * Returns 0 if successful, -ENOTDIR if the keyring isn't a keyring,
+ * -EKEYREVOKED if the keyring has been revoked, -ENFILE if the keyring is
+ * full, -EDQUOT if there is insufficient key data quota remaining to add
+ * another link or -ENOMEM if there's insufficient memory.
+ *
+ * It is assumed that the caller has checked that it is permitted for a link to
+ * be made (the keyring should have Write permission and the key Link
+ * permission).
  */
 int key_link(struct key *keyring, struct key *key)
 {
@@ -871,11 +937,24 @@ int key_link(struct key *keyring, struct key *key)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(key_link);
 
-/*
- * unlink the first link to a key from a keyring
+/**
+ * key_unlink - Unlink the first link to a key from a keyring.
+ * @keyring: The keyring to remove the link from.
+ * @key: The key the link is to.
+ *
+ * Remove a link from a keyring to a key.
+ *
+ * This function will write-lock the keyring's semaphore.
+ *
+ * Returns 0 if successful, -ENOTDIR if the keyring isn't a keyring, -ENOENT if
+ * the key isn't linked to by the keyring or -ENOMEM if there's insufficient
+ * memory.
+ *
+ * It is assumed that the caller has checked that it is permitted for a link to
+ * be removed (the keyring should have Write permission; no permissions are
+ * required on the key).
  */
 int key_unlink(struct key *keyring, struct key *key)
 {
@@ -944,12 +1023,11 @@ nomem:
 	up_write(&keyring->sem);
 	goto error;
 }
-
 EXPORT_SYMBOL(key_unlink);
 
 /*
- * dispose of a keyring list after the RCU grace period, releasing the keys it
- * links to
+ * Dispose of a keyring list after the RCU grace period, releasing the keys it
+ * links to.
  */
 static void keyring_clear_rcu_disposal(struct rcu_head *rcu)
 {
@@ -964,9 +1042,13 @@ static void keyring_clear_rcu_disposal(struct rcu_head *rcu)
 	kfree(klist);
 }
 
-/*
- * clear the specified process keyring
- * - implements keyctl(KEYCTL_CLEAR)
+/**
+ * keyring_clear - Clear a keyring
+ * @keyring: The keyring to clear.
+ *
+ * Clear the contents of the specified keyring.
+ *
+ * Returns 0 if successful or -ENOTDIR if the keyring isn't a keyring.
  */
 int keyring_clear(struct key *keyring)
 {
@@ -999,12 +1081,12 @@ int keyring_clear(struct key *keyring)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(keyring_clear);
 
 /*
- * dispose of the links from a revoked keyring
- * - called with the key sem write-locked
+ * Dispose of the links from a revoked keyring.
+ *
+ * This is called with the key sem write-locked.
  */
 static void keyring_revoke(struct key *keyring)
 {
@@ -1022,7 +1104,7 @@ static void keyring_revoke(struct key *keyring)
 }
 
 /*
- * Determine whether a key is dead
+ * Determine whether a key is dead.
  */
 static bool key_is_dead(struct key *key, time_t limit)
 {
@@ -1031,7 +1113,12 @@ static bool key_is_dead(struct key *key, time_t limit)
 }
 
 /*
- * Collect garbage from the contents of a keyring
+ * Collect garbage from the contents of a keyring, replacing the old list with
+ * a new one with the pointers all shuffled down.
+ *
+ * Dead keys are classed as oned that are flagged as being dead or are revoked,
+ * expired or negative keys that were revoked or expired before the specified
+ * limit.
  */
 void keyring_gc(struct key *keyring, time_t limit)
 {
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 6284b14..c35b522 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -1,4 +1,4 @@
-/* permission.c: key permission determination
+/* Key permission checking
  *
  * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -15,15 +15,17 @@
 
 /**
  * key_task_permission - Check a key can be used
- * @key_ref: The key to check
- * @cred: The credentials to use
- * @perm: The permissions to check for
+ * @key_ref: The key to check.
+ * @cred: The credentials to use.
+ * @perm: The permissions to check for.
  *
  * Check to see whether permission is granted to use a key in the desired way,
  * but permit the security modules to override.
  *
- * The caller must hold either a ref on cred or must hold the RCU readlock or a
- * spinlock.
+ * The caller must hold either a ref on cred or must hold the RCU readlock.
+ *
+ * Returns 0 if successful, -EACCES if access is denied based on the
+ * permissions bits or the LSM check.
  */
 int key_task_permission(const key_ref_t key_ref, const struct cred *cred,
 			key_perm_t perm)
@@ -79,11 +81,15 @@ use_these_perms:
 	/* let LSM be the final arbiter */
 	return security_key_permission(key_ref, cred, perm);
 }
-
 EXPORT_SYMBOL(key_task_permission);
 
-/*
- * validate a key
+/**
+ * key_validate - Validate a key.
+ * @key: The key to be validated.
+ *
+ * Check that a key is valid, returning 0 if the key is okay, -EKEYREVOKED if
+ * the key's type has been removed or if the key has been revoked or
+ * -EKEYEXPIRED if the key has expired.
  */
 int key_validate(struct key *key)
 {
@@ -109,5 +115,4 @@ int key_validate(struct key *key)
 error:
 	return ret;
 }
-
 EXPORT_SYMBOL(key_validate);
diff --git a/security/keys/proc.c b/security/keys/proc.c
index ad5f64e..525cf8a 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -1,4 +1,4 @@
-/* proc.c: proc files for key database enumeration
+/* procfs files for key database enumeration
  *
  * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -61,7 +61,7 @@ static const struct file_operations proc_key_users_fops = {
 };
 
 /*
- * declare the /proc files
+ * Declare the /proc files.
  */
 static int __init key_proc_init(void)
 {
@@ -83,7 +83,8 @@ static int __init key_proc_init(void)
 __initcall(key_proc_init);
 
 /*
- * implement "/proc/keys" to provides a list of the keys on the system
+ * Implement "/proc/keys" to provide a list of the keys on the system that
+ * grant View permission to the caller.
  */
 #ifdef CONFIG_KEYS_DEBUG_PROC_KEYS
 
@@ -291,7 +292,8 @@ static struct rb_node *key_user_first(struct rb_root *r)
 }
 
 /*
- * implement "/proc/key-users" to provides a list of the key users
+ * Implement "/proc/key-users" to provides a list of the key users and their
+ * quotas.
  */
 static int proc_key_users_open(struct inode *inode, struct file *file)
 {
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index ea55cf9..930634e 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -1,4 +1,4 @@
-/* Management of a process's keyrings
+/* Manage a process's keyrings
  *
  * Copyright (C) 2004-2005, 2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -21,13 +21,13 @@
 #include <asm/uaccess.h>
 #include "internal.h"
 
-/* session keyring create vs join semaphore */
+/* Session keyring create vs join semaphore */
 static DEFINE_MUTEX(key_session_mutex);
 
-/* user keyring creation semaphore */
+/* User keyring creation semaphore */
 static DEFINE_MUTEX(key_user_keyring_mutex);
 
-/* the root user's tracking struct */
+/* The root user's tracking struct */
 struct key_user root_key_user = {
 	.usage		= ATOMIC_INIT(3),
 	.cons_lock	= __MUTEX_INITIALIZER(root_key_user.cons_lock),
@@ -39,7 +39,7 @@ struct key_user root_key_user = {
 };
 
 /*
- * install user and user session keyrings for a particular UID
+ * Install the user and user session keyrings for the current process's UID.
  */
 int install_user_keyrings(void)
 {
@@ -121,7 +121,8 @@ error:
 }
 
 /*
- * install a fresh thread keyring directly to new credentials
+ * Install a fresh thread keyring directly to new credentials.  This keyring is
+ * allowed to overrun the quota.
  */
 int install_thread_keyring_to_cred(struct cred *new)
 {
@@ -137,7 +138,7 @@ int install_thread_keyring_to_cred(struct cred *new)
 }
 
 /*
- * install a fresh thread keyring, discarding the old one
+ * Install a fresh thread keyring, discarding the old one.
  */
 static int install_thread_keyring(void)
 {
@@ -160,9 +161,10 @@ static int install_thread_keyring(void)
 }
 
 /*
- * install a process keyring directly to a credentials struct
- * - returns -EEXIST if there was already a process keyring, 0 if one installed,
- *   and other -ve on any other error
+ * Install a process keyring directly to a credentials struct.
+ *
+ * Returns -EEXIST if there was already a process keyring, 0 if one installed,
+ * and other value on any other error
  */
 int install_process_keyring_to_cred(struct cred *new)
 {
@@ -191,8 +193,11 @@ int install_process_keyring_to_cred(struct cred *new)
 }
 
 /*
- * make sure a process keyring is installed
- * - we
+ * Make sure a process keyring is installed for the current process.  The
+ * existing process keyring is not replaced.
+ *
+ * Returns 0 if there is a process keyring by the end of this function, some
+ * error otherwise.
  */
 static int install_process_keyring(void)
 {
@@ -213,7 +218,7 @@ static int install_process_keyring(void)
 }
 
 /*
- * install a session keyring directly to a credentials struct
+ * Install a session keyring directly to a credentials struct.
  */
 int install_session_keyring_to_cred(struct cred *cred, struct key *keyring)
 {
@@ -253,8 +258,8 @@ int install_session_keyring_to_cred(struct cred *cred, struct key *keyring)
 }
 
 /*
- * install a session keyring, discarding the old one
- * - if a keyring is not supplied, an empty one is invented
+ * Install a session keyring, discarding the old one.  If a keyring is not
+ * supplied, an empty one is invented.
  */
 static int install_session_keyring(struct key *keyring)
 {
@@ -275,7 +280,7 @@ static int install_session_keyring(struct key *keyring)
 }
 
 /*
- * the filesystem user ID changed
+ * Handle the fsuid changing.
  */
 void key_fsuid_changed(struct task_struct *tsk)
 {
@@ -289,7 +294,7 @@ void key_fsuid_changed(struct task_struct *tsk)
 }
 
 /*
- * the filesystem group ID changed
+ * Handle the fsgid changing.
  */
 void key_fsgid_changed(struct task_struct *tsk)
 {
@@ -303,11 +308,25 @@ void key_fsgid_changed(struct task_struct *tsk)
 }
 
 /*
- * search only my process keyrings for the first matching key
- * - we use the supplied match function to see if the description (or other
- *   feature of interest) matches
- * - we return -EAGAIN if we didn't find any matching key
- * - we return -ENOKEY if we found only negative matching keys
+ * Search the process keyrings attached to the supplied cred for the first
+ * matching key.
+ *
+ * The search criteria are the type and the match function.  The description is
+ * given to the match function as a parameter, but doesn't otherwise influence
+ * the search.  Typically the match function will compare the description
+ * parameter to the key's description.
+ *
+ * This can only search keyrings that grant Search permission to the supplied
+ * credentials.  Keyrings linked to searched keyrings will also be searched if
+ * they grant Search permission too.  Keys can only be found if they grant
+ * Search permission to the credentials.
+ *
+ * Returns a pointer to the key with the key usage count incremented if
+ * successful, -EAGAIN if we didn't find any matching key or -ENOKEY if we only
+ * matched negative keys.
+ *
+ * In the case of a successful return, the possession attribute is set on the
+ * returned key reference.
  */
 key_ref_t search_my_process_keyrings(struct key_type *type,
 				     const void *description,
@@ -423,11 +442,12 @@ found:
 }
 
 /*
- * search the process keyrings for the first matching key
- * - we use the supplied match function to see if the description (or other
- *   feature of interest) matches
- * - we return -EAGAIN if we didn't find any matching key
- * - we return -ENOKEY if we found only negative matching keys
+ * Search the process keyrings attached to the supplied cred for the first
+ * matching key in the manner of search_my_process_keyrings(), but also search
+ * the keys attached to the assumed authorisation key using its credentials if
+ * one is available.
+ *
+ * Return same as search_my_process_keyrings().
  */
 key_ref_t search_process_keyrings(struct key_type *type,
 				  const void *description,
@@ -485,7 +505,7 @@ found:
 }
 
 /*
- * see if the key we're looking at is the target key
+ * See if the key we're looking at is the target key.
  */
 int lookup_user_key_possessed(const struct key *key, const void *target)
 {
@@ -493,9 +513,22 @@ int lookup_user_key_possessed(const struct key *key, const void *target)
 }
 
 /*
- * lookup a key given a key ID from userspace with a given permissions mask
- * - don't create special keyrings unless so requested
- * - partially constructed keys aren't found unless requested
+ * Look up a key ID given us by userspace with a given permissions mask to get
+ * the key it refers to.
+ *
+ * Flags can be passed to request that special keyrings be created if referred
+ * to directly, to permit partially constructed keys to be found and to skip
+ * validity and permission checks on the found key.
+ *
+ * Returns a pointer to the key with an incremented usage count if successful;
+ * -EINVAL if the key ID is invalid; -ENOKEY if the key ID does not correspond
+ * to a key or the best found key was a negative key; -EKEYREVOKED or
+ * -EKEYEXPIRED if the best found key was revoked or expired; -EACCES if the
+ * found key doesn't grant the requested permit or the LSM denied access to it;
+ * or -ENOMEM if a special keyring couldn't be created.
+ *
+ * In the case of a successful return, the possession attribute is set on the
+ * returned key reference.
  */
 key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
 			  key_perm_t perm)
@@ -703,10 +736,15 @@ reget_creds:
 }
 
 /*
- * join the named keyring as the session keyring if possible, or attempt to
- * create a new one of that name if not
- * - if the name is NULL, an empty anonymous keyring is installed instead
- * - named session keyring joining is done with a semaphore held
+ * Join the named keyring as the session keyring if possible else attempt to
+ * create a new one of that name and join that.
+ *
+ * If the name is NULL, an empty anonymous keyring will be installed as the
+ * session keyring.
+ *
+ * Named session keyrings are joined with a semaphore held to prevent the
+ * keyrings from going away whilst the attempt is made to going them and also
+ * to prevent a race in creating compatible session keyrings.
  */
 long join_session_keyring(const char *name)
 {
@@ -778,8 +816,8 @@ error:
 }
 
 /*
- * Replace a process's session keyring when that process resumes userspace on
- * behalf of one of its children
+ * Replace a process's session keyring on behalf of one of its children when
+ * the target  process is about to resume userspace execution.
  */
 void key_replace_session_keyring(void)
 {
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 0ea52d2..9a7fb39 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -39,8 +39,14 @@ static int key_wait_bit_intr(void *flags)
 	return signal_pending(current) ? -ERESTARTSYS : 0;
 }
 
-/*
- * call to complete the construction of a key
+/**
+ * complete_request_key - Complete the construction of a key.
+ * @cons: The key construction record.
+ * @error: The success or failute of the construction.
+ *
+ * Complete the attempt to construct a key.  The key will be negated
+ * if an error is indicated.  The authorisation key will be revoked
+ * unconditionally.
  */
 void complete_request_key(struct key_construction *cons, int error)
 {
@@ -58,23 +64,33 @@ void complete_request_key(struct key_construction *cons, int error)
 }
 EXPORT_SYMBOL(complete_request_key);
 
+/*
+ * Initialise a usermode helper that is going to have a specific session
+ * keyring.
+ *
+ * This is called in context of freshly forked kthread before kernel_execve(),
+ * so we can simply install the desired session_keyring at this point.
+ */
 static int umh_keys_init(struct subprocess_info *info)
 {
 	struct cred *cred = (struct cred*)current_cred();
 	struct key *keyring = info->data;
-	/*
-	 * This is called in context of freshly forked kthread before
-	 * kernel_execve(), we can just change our ->session_keyring.
-	 */
+
 	return install_session_keyring_to_cred(cred, keyring);
 }
 
+/*
+ * Clean up a usermode helper with session keyring.
+ */
 static void umh_keys_cleanup(struct subprocess_info *info)
 {
 	struct key *keyring = info->data;
 	key_put(keyring);
 }
 
+/*
+ * Call a usermode helper with a specific session keyring.
+ */
 static int call_usermodehelper_keys(char *path, char **argv, char **envp,
 			 struct key *session_keyring, enum umh_wait wait)
 {
@@ -91,7 +107,7 @@ static int call_usermodehelper_keys(char *path, char **argv, char **envp,
 }
 
 /*
- * request userspace finish the construction of a key
+ * Request userspace finish the construction of a key
  * - execute "/sbin/request-key <op> <key> <uid> <gid> <keyring> <keyring> <keyring>"
  */
 static int call_sbin_request_key(struct key_construction *cons,
@@ -198,8 +214,9 @@ error_alloc:
 }
 
 /*
- * call out to userspace for key construction
- * - we ignore program failure and go on key status instead
+ * Call out to userspace for key construction.
+ *
+ * Program failure is ignored in favour of key status.
  */
 static int construct_key(struct key *key, const void *callout_info,
 			 size_t callout_len, void *aux,
@@ -246,9 +263,10 @@ static int construct_key(struct key *key, const void *callout_info,
 }
 
 /*
- * get the appropriate destination keyring for the request
- * - we return whatever keyring we select with an extra reference upon it which
- *   the caller must release
+ * Get the appropriate destination keyring for the request.
+ *
+ * The keyring selected is returned with an extra reference upon it which the
+ * caller must release.
  */
 static void construct_get_dest_keyring(struct key **_dest_keyring)
 {
@@ -321,9 +339,11 @@ static void construct_get_dest_keyring(struct key **_dest_keyring)
 }
 
 /*
- * allocate a new key in under-construction state and attempt to link it in to
- * the requested place
- * - may return a key that's already under construction instead
+ * Allocate a new key in under-construction state and attempt to link it in to
+ * the requested keyring.
+ *
+ * May return a key that's already under construction instead if there was a
+ * race between two thread calling request_key().
  */
 static int construct_alloc_key(struct key_type *type,
 			       const char *description,
@@ -414,7 +434,7 @@ alloc_failed:
 }
 
 /*
- * commence key construction
+ * Commence key construction.
  */
 static struct key *construct_key_and_link(struct key_type *type,
 					  const char *description,
@@ -465,12 +485,32 @@ construction_failed:
 	return ERR_PTR(ret);
 }
 
-/*
- * request a key
- * - search the process's keyrings
- * - check the list of keys being created or updated
- * - call out to userspace for a key if supplementary info was provided
- * - cache the key in an appropriate keyring
+/**
+ * request_key_and_link - Request a key and cache it in a keyring.
+ * @type: The type of key we want.
+ * @description: The searchable description of the key.
+ * @callout_info: The data to pass to the instantiation upcall (or NULL).
+ * @callout_len: The length of callout_info.
+ * @aux: Auxiliary data for the upcall.
+ * @dest_keyring: Where to cache the key.
+ * @flags: Flags to key_alloc().
+ *
+ * A key matching the specified criteria is searched for in the process's
+ * keyrings and returned with its usage count incremented if found.  Otherwise,
+ * if callout_info is not NULL, a key will be allocated and some service
+ * (probably in userspace) will be asked to instantiate it.
+ *
+ * If successfully found or created, the key will be linked to the destination
+ * keyring if one is provided.
+ *
+ * Returns a pointer to the key if successful; -EACCES, -ENOKEY, -EKEYREVOKED
+ * or -EKEYEXPIRED if an inaccessible, negative, revoked or expired key was
+ * found; -ENOKEY if no key was found and no @callout_info was given; -EDQUOT
+ * if insufficient key quota was available to create a new key; or -ENOMEM if
+ * insufficient memory was available.
+ *
+ * If the returned key was created, then it may still be under construction,
+ * and wait_for_key_construction() should be used to wait for that to complete.
  */
 struct key *request_key_and_link(struct key_type *type,
 				 const char *description,
@@ -524,8 +564,16 @@ error:
 	return key;
 }
 
-/*
- * wait for construction of a key to complete
+/**
+ * wait_for_key_construction - Wait for construction of a key to complete
+ * @key: The key being waited for.
+ * @intr: Whether to wait interruptibly.
+ *
+ * Wait for a key to finish being constructed.
+ *
+ * Returns 0 if successful; -ERESTARTSYS if the wait was interrupted; -ENOKEY
+ * if the key was negated; or -EKEYREVOKED or -EKEYEXPIRED if the key was
+ * revoked or expired.
  */
 int wait_for_key_construction(struct key *key, bool intr)
 {
@@ -542,12 +590,19 @@ int wait_for_key_construction(struct key *key, bool intr)
 }
 EXPORT_SYMBOL(wait_for_key_construction);
 
-/*
- * request a key
- * - search the process's keyrings
- * - check the list of keys being created or updated
- * - call out to userspace for a key if supplementary info was provided
- * - waits uninterruptible for creation to complete
+/**
+ * request_key - Request a key and wait for construction
+ * @type: Type of key.
+ * @description: The searchable description of the key.
+ * @callout_info: The data to pass to the instantiation upcall (or NULL).
+ *
+ * As for request_key_and_link() except that it does not add the returned key
+ * to a keyring if found, new keys are always allocated in the user's quota,
+ * the callout_info must be a NUL-terminated string and no auxiliary data can
+ * be passed.
+ *
+ * Furthermore, it then works as wait_for_key_construction() to wait for the
+ * completion of keys undergoing construction with a non-interruptible wait.
  */
 struct key *request_key(struct key_type *type,
 			const char *description,
@@ -572,12 +627,19 @@ struct key *request_key(struct key_type *type,
 }
 EXPORT_SYMBOL(request_key);
 
-/*
- * request a key with auxiliary data for the upcaller
- * - search the process's keyrings
- * - check the list of keys being created or updated
- * - call out to userspace for a key if supplementary info was provided
- * - waits uninterruptible for creation to complete
+/**
+ * request_key_with_auxdata - Request a key with auxiliary data for the upcaller
+ * @type: The type of key we want.
+ * @description: The searchable description of the key.
+ * @callout_info: The data to pass to the instantiation upcall (or NULL).
+ * @callout_len: The length of callout_info.
+ * @aux: Auxiliary data for the upcall.
+ *
+ * As for request_key_and_link() except that it does not add the returned key
+ * to a keyring if found and new keys are always allocated in the user's quota.
+ *
+ * Furthermore, it then works as wait_for_key_construction() to wait for the
+ * completion of keys undergoing construction with a non-interruptible wait.
  */
 struct key *request_key_with_auxdata(struct key_type *type,
 				     const char *description,
@@ -602,10 +664,18 @@ struct key *request_key_with_auxdata(struct key_type *type,
 EXPORT_SYMBOL(request_key_with_auxdata);
 
 /*
- * request a key (allow async construction)
- * - search the process's keyrings
- * - check the list of keys being created or updated
- * - call out to userspace for a key if supplementary info was provided
+ * request_key_async - Request a key (allow async construction)
+ * @type: Type of key.
+ * @description: The searchable description of the key.
+ * @callout_info: The data to pass to the instantiation upcall (or NULL).
+ * @callout_len: The length of callout_info.
+ *
+ * As for request_key_and_link() except that it does not add the returned key
+ * to a keyring if found, new keys are always allocated in the user's quota and
+ * no auxiliary data can be passed.
+ *
+ * The caller should call wait_for_key_construction() to wait for the
+ * completion of the returned key if it is still undergoing construction.
  */
 struct key *request_key_async(struct key_type *type,
 			      const char *description,
@@ -620,9 +690,17 @@ EXPORT_SYMBOL(request_key_async);
 
 /*
  * request a key with auxiliary data for the upcaller (allow async construction)
- * - search the process's keyrings
- * - check the list of keys being created or updated
- * - call out to userspace for a key if supplementary info was provided
+ * @type: Type of key.
+ * @description: The searchable description of the key.
+ * @callout_info: The data to pass to the instantiation upcall (or NULL).
+ * @callout_len: The length of callout_info.
+ * @aux: Auxiliary data for the upcall.
+ *
+ * As for request_key_and_link() except that it does not add the returned key
+ * to a keyring if found and new keys are always allocated in the user's quota.
+ *
+ * The caller should call wait_for_key_construction() to wait for the
+ * completion of the returned key if it is still undergoing construction.
  */
 struct key *request_key_async_with_auxdata(struct key_type *type,
 					   const char *description,
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index ba717b8..6816403 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -1,4 +1,4 @@
-/* request_key_auth.c: request key authorisation controlling key def
+/* Request key authorisation token key definition.
  *
  * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -26,7 +26,7 @@ static void request_key_auth_destroy(struct key *);
 static long request_key_auth_read(const struct key *, char __user *, size_t);
 
 /*
- * the request-key authorisation key type definition
+ * The request-key authorisation key type definition.
  */
 struct key_type key_type_request_key_auth = {
 	.name		= ".request_key_auth",
@@ -39,7 +39,7 @@ struct key_type key_type_request_key_auth = {
 };
 
 /*
- * instantiate a request-key authorisation key
+ * Instantiate a request-key authorisation key.
  */
 static int request_key_auth_instantiate(struct key *key,
 					const void *data,
@@ -50,7 +50,7 @@ static int request_key_auth_instantiate(struct key *key,
 }
 
 /*
- * reading a request-key authorisation key retrieves the callout information
+ * Describe an authorisation token.
  */
 static void request_key_auth_describe(const struct key *key,
 				      struct seq_file *m)
@@ -63,7 +63,7 @@ static void request_key_auth_describe(const struct key *key,
 }
 
 /*
- * read the callout_info data
+ * Read the callout_info data (retrieves the callout information).
  * - the key's semaphore is read-locked
  */
 static long request_key_auth_read(const struct key *key,
@@ -89,8 +89,9 @@ static long request_key_auth_read(const struct key *key,
 }
 
 /*
- * handle revocation of an authorisation token key
- * - called with the key sem write-locked
+ * Handle revocation of an authorisation token key.
+ *
+ * Called with the key sem write-locked.
  */
 static void request_key_auth_revoke(struct key *key)
 {
@@ -105,7 +106,7 @@ static void request_key_auth_revoke(struct key *key)
 }
 
 /*
- * destroy an instantiation authorisation token key
+ * Destroy an instantiation authorisation token key.
  */
 static void request_key_auth_destroy(struct key *key)
 {
@@ -125,8 +126,8 @@ static void request_key_auth_destroy(struct key *key)
 }
 
 /*
- * create an authorisation token for /sbin/request-key or whoever to gain
- * access to the caller's security data
+ * Create an authorisation token for /sbin/request-key or whoever to gain
+ * access to the caller's security data.
  */
 struct key *request_key_auth_new(struct key *target, const void *callout_info,
 				 size_t callout_len, struct key *dest_keyring)
@@ -220,7 +221,7 @@ error_alloc:
 }
 
 /*
- * see if an authorisation key is associated with a particular key
+ * See if an authorisation key is associated with a particular key.
  */
 static int key_get_instantiation_authkey_match(const struct key *key,
 					       const void *_id)
@@ -232,11 +233,8 @@ static int key_get_instantiation_authkey_match(const struct key *key,
 }
 
 /*
- * get the authorisation key for instantiation of a specific key if attached to
- * the current process's keyrings
- * - this key is inserted into a keyring and that is set as /sbin/request-key's
- *   session keyring
- * - a target_id of zero specifies any valid token
+ * Search the current process's keyrings for the authorisation key for
+ * instantiation of a key.
  */
 struct key *key_get_instantiation_authkey(key_serial_t target_id)
 {

