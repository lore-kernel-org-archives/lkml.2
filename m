Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1C1QkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:40:04 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59707 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1C1QkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:40:00 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Subject: [PATCH v4 00/11] EVM
Date: Mon, 28 Mar 2011 12:39:31 -0400
Message-Id: <1301330382-17745-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extended Verification Module(EVM) detects offline tampering of the security
extended attributes (e.g. security.selinux, security.SMACK64, security.ima),
which is the basis for LSM permission decisions and, with the IMA-appraisal
patchset, integrity appraisal decisions. This patchset provides the framework
and an initial method to detect offline tampering of the security extended
attributes.  The initial method maintains an HMAC-sha1 across a set of
security extended attributes, storing the HMAC as the extended attribute
'security.evm'. To verify the integrity of an extended attribute, EVM exports
evm_verifyxattr(), which re-calculates the HMAC and compares it with the
version stored in 'security.evm'.  Other methods of validating the integrity
of a file's metadata will be posted separately (eg. EVM-digital-signatures).

While this patchset does authenticate the security xattrs, and
cryptographically binds them to the inode, coming extensions will bind other
directory and inode metadata for more complete protection.  To help simplify
the review and upstreaming process, each extension will be posted separately
(eg. IMA-appraisal, IMA-appraisal-directory).  For a general overview of the
proposed Linux integrity subsystem, refer to Dave Safford's whitepaper:
http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf.

Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
reviewing the original patches.

Mimi Zohar
David Safford

Dmitry Kasatkin (2):
  evm: add support for different security.evm data types
  evm: crypto hash replaced by shash

Mimi Zohar (9):
  integrity: move ima inode integrity data management
  xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
  evm: re-release
  ima: move ima_file_free before releasing the file
  security: imbed evm calls in security hooks
  evm: inode post removexattr
  evm: imbed evm_inode_post_setattr
  evm: inode_post_init
  fs: add evm_inode_post_init calls

 Documentation/ABI/testing/evm       |   23 +++
 fs/attr.c                           |    5 +-
 fs/ext2/xattr_security.c            |   31 +++-
 fs/ext3/xattr_security.c            |   30 +++-
 fs/ext4/xattr_security.c            |   30 +++-
 fs/file_table.c                     |    2 +-
 fs/xattr.c                          |   63 +++++++-
 include/linux/evm.h                 |   82 +++++++++
 include/linux/ima.h                 |   13 --
 include/linux/integrity.h           |   43 +++++
 include/linux/xattr.h               |   14 ++-
 security/Kconfig                    |    2 +-
 security/Makefile                   |    4 +-
 security/integrity/Kconfig          |    7 +
 security/integrity/Makefile         |   12 ++
 security/integrity/evm/Kconfig      |   12 ++
 security/integrity/evm/Makefile     |    6 +
 security/integrity/evm/evm.h        |   39 +++++
 security/integrity/evm/evm_crypto.c |  211 +++++++++++++++++++++++
 security/integrity/evm/evm_main.c   |  323 +++++++++++++++++++++++++++++++++++
 security/integrity/evm/evm_secfs.c  |  108 ++++++++++++
 security/integrity/iint.c           |  171 ++++++++++++++++++
 security/integrity/ima/Kconfig      |    1 +
 security/integrity/ima/Makefile     |    2 +-
 security/integrity/ima/ima.h        |   29 +---
 security/integrity/ima/ima_api.c    |    7 +-
 security/integrity/ima/ima_iint.c   |  169 ------------------
 security/integrity/ima/ima_main.c   |   12 +-
 security/integrity/integrity.h      |   38 ++++
 security/security.c                 |   19 ++-
 30 files changed, 1265 insertions(+), 243 deletions(-)
 create mode 100644 Documentation/ABI/testing/evm
 create mode 100644 include/linux/evm.h
 create mode 100644 include/linux/integrity.h
 create mode 100644 security/integrity/Kconfig
 create mode 100644 security/integrity/Makefile
 create mode 100644 security/integrity/evm/Kconfig
 create mode 100644 security/integrity/evm/Makefile
 create mode 100644 security/integrity/evm/evm.h
 create mode 100644 security/integrity/evm/evm_crypto.c
 create mode 100644 security/integrity/evm/evm_main.c
 create mode 100644 security/integrity/evm/evm_secfs.c
 create mode 100644 security/integrity/iint.c
 delete mode 100644 security/integrity/ima/ima_iint.c
 create mode 100644 security/integrity/integrity.h

-- 
1.7.3.4

