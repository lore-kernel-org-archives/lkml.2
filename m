Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2LOIUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 03:20:36 -0500
Received: from tundra.namei.org ([65.99.196.166]:56563 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab2LOIUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 03:20:34 -0500
Date: Sat, 15 Dec 2012 19:28:26 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.8
Message-ID: <alpine.LRH.2.02.1212151925410.27388@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quiet cycle for the security subsystem with just a few maintenance 
updates.

Please pull.

The following changes since commit 7a280cf512053137a37da2801eac73a8842fa50d:
  Linus Torvalds (1):
        Merge tag 'disintegrate-x86-20121214' of git://git.infradead.org/users/dhowells/linux-headers

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Alan Cox (2):
      keys: Fix unreachable code
      key: Fix resource leak

Andy Lutomirski (1):
      seccomp: Make syscall skipping and nr changes more consistent

Ashley Lai (1):
      drivers/char/tpm: remove tasklet and cleanup

Casey Schaufler (2):
      Smack: use select not depends in Kconfig
      Smack: create a sysfs mount point for smackfs

David Howells (5):
      KEYS: Add payload preparsing opportunity prior to key instantiate or update
      KEYS: Make the session and process keyrings per-thread
      KEYS: Reduce initial permissions on keys
      KEYS: Use keyring_alloc() to create special keyrings
      Merge branch 'modsign-keys-devel' into security-next-keys

James Morris (2):
      Merge branch 'security-next-keys' of git://git.kernel.org/.../dhowells/security-keys into next-queue
      Merge tag 'yama-3.8' of git://git.kernel.org/.../kees/linux into next

Kees Cook (2):
      Yama: add RCU to drop read locking
      Yama: remove locking from delete path

 Documentation/prctl/seccomp_filter.txt   |   74 +++++++++++++++--
 Documentation/security/keys.txt          |   67 +++++++++++++++-
 arch/x86/kernel/vsyscall_64.c            |  110 ++++++++++++++------------
 drivers/char/tpm/tpm_ibmvtpm.c           |   81 +++++++------------
 drivers/char/tpm/tpm_ibmvtpm.h           |    5 +-
 fs/cifs/cifs_spnego.c                    |    6 +-
 fs/cifs/cifsacl.c                        |   20 ++---
 fs/nfs/idmap.c                           |   12 +--
 include/keys/user-type.h                 |    6 +-
 include/linux/cred.h                     |   17 +---
 include/linux/key-type.h                 |   35 +++++++-
 include/linux/key.h                      |    1 +
 kernel/cred.c                            |  127 ++++--------------------------
 kernel/seccomp.c                         |   13 ++-
 net/ceph/crypto.c                        |    9 ++-
 net/dns_resolver/dns_key.c               |   19 ++---
 net/rxrpc/ar-key.c                       |   40 +++++-----
 security/keys/encrypted-keys/encrypted.c |   16 ++--
 security/keys/key.c                      |  120 ++++++++++++++++++++--------
 security/keys/keyctl.c                   |   33 +++++---
 security/keys/keyring.c                  |   16 ++--
 security/keys/process_keys.c             |   94 +++++++++-------------
 security/keys/request_key.c              |   21 +++--
 security/keys/request_key_auth.c         |    8 +-
 security/keys/trusted.c                  |   16 ++--
 security/keys/user_defined.c             |   14 ++--
 security/smack/Kconfig                   |    6 +-
 security/smack/smackfs.c                 |   17 ++++
 security/yama/yama_lsm.c                 |   88 +++++++++++++++------
 29 files changed, 618 insertions(+), 473 deletions(-)
