Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1AJAqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 19:46:11 -0500
Received: from tundra.namei.org ([65.99.196.166]:46547 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab1AJAqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 19:46:09 -0500
Date: Mon, 10 Jan 2011 11:46:04 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem changes for 2.6.38
Message-ID: <alpine.LRH.2.00.1101101136001.21289@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not a great deal of change for this kernel.  The trusted and encrypted keys 
from Mimi are new, and Smack has a couple of enhancements arising from 
Meego integration, otherwise it's mostly bugfixes and minor updates.

Also, following discussion at the kernel summit, several sub-maintainers 
have now established public git trees from which I pull.

Please pull.


The following changes since commit 0c21e3aaf6ae85bee804a325aa29c325209180fd:
  Linus Torvalds (1):
        Merge branch 'for-next' of git://git.kernel.org/.../hch/hfsplus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Casey Schaufler (2):
      Smack: UDS revision
      This patch adds a new security attribute to Smack called SMACK64EXEC.

Eric Paris (12):
      SELinux: standardize return code handling in policydb.c
      SELinux: standardize return code handling in selinuxfs.c
      SELinux: standardize return code handling in selinuxfs.c
      selinux: rework security_netlbl_secattr_to_sid
      SELinux: do not set automatic i_ino in selinuxfs
      flex_array: fix flex_array_put_ptr macro to be valid C
      selinux: convert type_val_to_struct to flex_array
      selinux: convert part of the sym_val_to_name array to use flex_array
      SELinux: merge policydb_index_classes and policydb_index_others
      SELinux: do not compute transition labels on mountpoint labeled filesystems
      selinux: cache sidtab_context_to_sid results
      SELinux: define permissions for DCB netlink messages

James Morris (5):
      kernel: add roundup() code comment from akpm
      Merge branch 'master' into next
      Merge branch 'smack-next-master' into next
      Merge branch 'master' into next
      Merge branch 'master' of git://git.infradead.org/users/eparis/selinux into next

Jarkko Sakkinen (1):
      Smack: Transmute labels on specified directories

Mimi Zohar (10):
      lib: hex2bin converts ascii hexadecimal string to binary
      tpm: add module_put wrapper
      key: add tpm_send command
      keys: add new trusted key-type
      keys: add new key-type encrypted
      keys: add missing include file for trusted and encrypted keys
      trusted-keys: additional TSS return code and other error handling
      trusted-keys: kzalloc and other cleanup
      encrypted-keys: verify datablob size before converting to binary
      encrypted-keys: style and other cleanup

Serge E. Hallyn (2):
      security: Define CAP_SYSLOG
      syslog: check cap_syslog when dmesg_restrict

Tetsuo Handa (2):
      security: Fix comment of security_key_permission
      MAINTAINERS: Add tomoyo-dev-en ML.

 Documentation/keys-trusted-encrypted.txt |  145 ++++
 Documentation/sysctl/kernel.txt          |    2 +-
 MAINTAINERS                              |    3 +-
 drivers/char/tpm/tpm.c                   |   20 +-
 drivers/char/tpm/tpm.h                   |    5 +
 include/keys/encrypted-type.h            |   29 +
 include/keys/trusted-type.h              |   31 +
 include/linux/capability.h               |    7 +-
 include/linux/flex_array.h               |    2 +-
 include/linux/kernel.h                   |    3 +
 include/linux/security.h                 |    3 +-
 include/linux/tpm.h                      |    4 +
 include/linux/tpm_command.h              |   28 +
 include/linux/xattr.h                    |    4 +
 kernel/printk.c                          |   14 +-
 lib/hexdump.c                            |   16 +
 security/Kconfig                         |   31 +
 security/keys/Makefile                   |    2 +
 security/keys/encrypted_defined.c        |  903 +++++++++++++++++++++++
 security/keys/encrypted_defined.h        |   54 ++
 security/keys/trusted_defined.c          | 1175 ++++++++++++++++++++++++++++++
 security/keys/trusted_defined.h          |  134 ++++
 security/selinux/hooks.c                 |    5 +-
 security/selinux/include/classmap.h      |    2 +-
 security/selinux/nlmsgtab.c              |    2 +
 security/selinux/selinuxfs.c             |  649 ++++++++---------
 security/selinux/ss/conditional.c        |    6 +-
 security/selinux/ss/mls.c                |   25 +-
 security/selinux/ss/policydb.c           |  701 +++++++++---------
 security/selinux/ss/policydb.h           |   19 +-
 security/selinux/ss/services.c           |  425 ++++++------
 security/selinux/ss/sidtab.c             |   39 +-
 security/selinux/ss/sidtab.h             |    2 +
 security/smack/smack.h                   |   45 ++
 security/smack/smack_access.c            |   58 ++-
 security/smack/smack_lsm.c               |  354 +++++++---
 security/smack/smackfs.c                 |   41 +-
 37 files changed, 3914 insertions(+), 1074 deletions(-)
 create mode 100644 Documentation/keys-trusted-encrypted.txt
 create mode 100644 include/keys/encrypted-type.h
 create mode 100644 include/keys/trusted-type.h
 create mode 100644 include/linux/tpm_command.h
 create mode 100644 security/keys/encrypted_defined.c
 create mode 100644 security/keys/encrypted_defined.h
 create mode 100644 security/keys/trusted_defined.c
 create mode 100644 security/keys/trusted_defined.h

-- 
James Morris
<jmorris@namei.org>
