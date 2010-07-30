Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0G3I7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 04:59:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:37425 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab0G3I72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 04:59:28 -0400
Date: Fri, 30 Jul 2010 18:59:27 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: linux-kernel@vger.kernel.org
cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a summary of changes to the security subsystem for the 
2.6.36 kernel, which may be found in my development tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

One issue which needs to be addressed is to confirm that there is 
consensus on the new Yama LSM module.  I had thought there was, based on 
list discussion, but have since had differing feedback.

----

Arnd Bergmann (2):
      ima: use generic_file_llseek for securityfs
      selinux: use generic_file_llseek

Chihau Chau (1):
      Security: capability: code style issue

Dan Carpenter (9):
      smack: opt_dentry is never null in in smack_d_instantiate()
      KEYS: Propagate error code instead of returning -EINVAL
      selinux: cleanup return codes in avtab_read_item()
      selinux: propagate error codes in cond_read_list()
      selinux: fix error codes in cond_read_av_list()
      selinux: fix error codes in cond_read_node()
      selinux: fix error codes in cond_policydb_init()
      selinux: fix error codes in cond_read_bool()
      selinux: fix error codes in symtab_init()

David Howells (3):
      KEYS: Authorise keyctl_set_timeout() on a key if we have its authorisation key
      KEYS: Make /proc/keys check to see if a key is possessed before security check
      KEYS: Use the variable 'key' in keyctl_describe_key()

Eric Paris (8):
      SELinux: seperate range transition rules to a seperate function
      SELinux: move genfs read to a separate function
      SELinux: break ocontext reading into a separate function
      vfs: re-introduce MAY_CHDIR
      security: make LSMs explicitly mask off permissions
      SELinux: special dontaudit for access checks
      selinux: place open in the common file perms
      SELinux: Move execmod to the common perms

James Morris (3):
      Merge branch 'next-queue' into next
      AppArmor: update path_truncate method to latest version
      Merge branch 'master' into next-preview

John Johansen (14):
      AppArmor: misc. base functions and defines
      AppArmor: basic auditing infrastructure.
      AppArmor: contexts used in attaching policy to system objects
      AppArmor: dfa match engine
      AppArmor: userspace interfaces
      AppArmor: file enforcement routines
      AppArmor: functions for domain transitions
      AppArmor: update Maintainer and Documentation
      AppArmor: Enable configuring and building of the AppArmor security module
      AppArmor: LSM interface, and security module initialization
      AppArmor: mediation of non file objects
      AppArmor: policy routines for loading and unpacking policy
      AppArmor: core policy routines
      AppArmor: Enable configuring and building of the AppArmor security module

Justin P. Mattock (1):
      KEYS: Reinstate lost passing of process keyring ID in call_sbin_request_key()

Kees Cook (3):
      security: Yama LSM
      Yama: turn process ancestry check into function
      Yama: verify inode is symlink to avoid bind mounts

Mimi Zohar (1):
      security: move LSM xattrnames to xattr.h

Paul E. McKenney (1):
      selinux: remove all rcu head initializations

Paul Moore (5):
      selinux: Set the peer label correctly on connected UNIX domain sockets
      selinux: Consolidate sockcreate_sid logic
      selinux: Shuffle the sk_security_struct alloc and free routines
      selinux: Convert socket related access controls to use socket labels
      selinux: Use current_security() when possible

Rajiv Andrade (1):
      tpm_tis: fix subsequent suspend failures

Tetsuo Handa (42):
      TOMOYO: Add numeric values grouping support.
      TOMOYO: Use structure for passing common arguments.
      TOMOYO: Split file access control functions by type of parameters.
      TOMOYO: Add mount restriction.
      TOMOYO: Add interactive enforcing mode.
      TOMOYO: Split files into some pieces.
      LSM: Remove unused arguments from security_path_truncate().
      TOMOYO: Several fixes for TOMOYO's management programs.
      TOMOYO: Support longer pathname.
      TOMOYO: Allow wildcard for execute permission.
      TOMOYO: Add pathname aggregation support.
      TOMOYO: Update profile structure.
      TOMOYO: Use callback for updating entries.
      TOMOYO: Use common structure for list element.
      TOMOYO: Use callback for updating entries.
      TOMOYO: Use common code for garbage collection.
      TOMOYO: Use common code for open and mkdir etc.
      TOMOYO: Pass parameters via structure.
      TOMOYO: Use callback for permission check.
      TOMOYO: Rename symbols.
      TOMOYO: Loosen parameter check for mount operation.
      TOMOYO: Remove wrapper function for reading keyword.
      TOMOYO: Merge functions.
      TOMOYO: Make read function to void.
      TOMOYO: Pass "struct list_head" rather than "void *".
      TOMOYO: Merge tomoyo_path_group and tomoyo_number_group
      TOMOYO: Use array of "struct list_head".
      TOMOYO: Aggregate reader functions.
      TOMOYO: Merge path_group and number_group.
      TOMOYO: Remove alias keyword.
      TOMOYO: Use common code for domain transition control.
      TOMOYO: Change list iterator.
      TOMOYO: Allow reading only execute permission.
      TOMOYO: Use common code for policy reading.
      TOMOYO: Copy directly to userspace buffer.
      TOMOYO: Small cleanup.
      TOMOYO: Rename symbols.
      TOMOYO: Add missing poll() hook.
      TOMOYO: Explicitly set file_operations->llseek pointer.
      TOMOYO: Fix quota check.
      TOMOYO: Update version to 2.3.0
      TOMOYO: Use pathname specified by policy rather than execve()

Tvrtko Ursulin (1):
      securityfs: Drop dentry reference count when mknod fails



-- 
James Morris
<jmorris@namei.org>
