Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0DUWlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:41:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42194 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0DUWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:41:43 -0400
Subject: Re: [PATCH 00/14] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <4BCF7ADB.6080409@oracle.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20100421145848.b36ab7bd.randy.dunlap@oracle.com>
	 <1271888338.2650.13.camel@localhost.localdomain>
	 <4BCF7ADB.6080409@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 18:41:28 -0400
Message-ID: <1271889688.2650.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 15:23 -0700, Randy Dunlap wrote:
> On 04/21/10 15:18, Mimi Zohar wrote:
> > On Wed, 2010-04-21 at 14:58 -0700, Randy Dunlap wrote:
> >> On Wed, 21 Apr 2010 17:49:40 -0400 Mimi Zohar wrote:
> >>
> >>> Extended Verification Module(EVM) detects offline tampering of the
> >>> security extended attributes (e.g. security.selinux, security.SMACK64,
> >>> security.ima), which is the basis for LSM permission decisions and,
> >>> with this set of patches, integrity appraisal decisions. To detect
> >>> offline tampering of the extended attributes, EVM maintains an
> >>> HMAC-sha1 across a set of security extended attributes, storing the
> >>> HMAC as the extended attribute 'security.evm'. To verify the integrity
> >>> of an extended attribute, EVM exports evm_verifyxattr(), which
> >>> re-calculates the HMAC and compares it with the version stored in
> >>> 'security.evm'.
> >>>
> >> ...
> >>>
> >>> Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
> >>> reviewing the patches.
> >>>
> >>> Mimi
> >>>
> >>> Mimi Zohar (14):
> >>>   integrity: move ima inode integrity data management
> >>>   security: move LSM xattrnames to xattr.h
> >>>   xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
> >>>   evm: re-release
> >>>   ima: move ima_file_free before releasing the file
> >>>   security: imbed evm calls in security hooks
> >>>   evm: inode post removexattr
> >>>   evm: imbed evm_inode_post_setattr
> >>>   evm: inode_post_init
> >>>   fs: add evm_inode_post_init calls
> >>>   ima: integrity appraisal extension
> >>>   ima: appraise default rules
> >>>   ima: inode post_setattr
> >>>   ima: add ima_inode_setxattr and ima_inode_removexattr
> >>> --
> >>
> >> A summary diffstat would be good to see in patch 00/14.
> >>
> >> Lacking that, at least each individual patch should have a diffstat summary
> >> in it.  Please read Documentation/SubmittingPatches.
> >>
> >> ---
> >> ~Randy
> >

Documentation/kernel-parameters.txt   |    4 +
 fs/attr.c                             |    7 +-
 fs/ext2/xattr_security.c              |   31 +++-
 fs/ext3/xattr_security.c              |   30 +++-
 fs/ext4/xattr_security.c              |   30 +++-
 fs/file_table.c                       |    2 +-
 fs/xattr.c                            |   63 ++++++-
 include/linux/capability.h            |    3 -
 include/linux/evm.h                   |   80 ++++++++
 include/linux/ima.h                   |   27 ++-
 include/linux/integrity.h             |   35 ++++
 include/linux/xattr.h                 |   27 +++-
 security/Kconfig                      |    2 +-
 security/Makefile                     |    4 +-
 security/integrity/Kconfig            |    7 +
 security/integrity/Makefile           |   12 ++
 security/integrity/evm/Kconfig        |   13 ++
 security/integrity/evm/Makefile       |    7 +
 security/integrity/evm/evm.h          |   38 ++++
 security/integrity/evm/evm_crypto.c   |  198 +++++++++++++++++++
 security/integrity/evm/evm_main.c     |  335 +++++++++++++++++++++++++++++++++
 security/integrity/evm/evm_secfs.c    |  108 +++++++++++
 security/integrity/iint.c             |  153 +++++++++++++++
 security/integrity/ima/Kconfig        |   15 ++
 security/integrity/ima/Makefile       |    4 +-
 security/integrity/ima/ima.h          |   76 +++++---
 security/integrity/ima/ima_api.c      |   61 +++++--
 security/integrity/ima/ima_appraise.c |  152 +++++++++++++++
 security/integrity/ima/ima_iint.c     |  145 --------------
 security/integrity/ima/ima_main.c     |  123 ++++++++++---
 security/integrity/ima/ima_policy.c   |   61 ++++++-
 security/integrity/integrity.h        |   50 +++++
 security/security.c                   |   27 +++-
 security/selinux/hooks.c              |    3 -
 security/smack/smack.h                |    2 -
 35 files changed, 1671 insertions(+), 264 deletions(-)
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
 create mode 100644 security/integrity/ima/ima_appraise.c
 delete mode 100644 security/integrity/ima/ima_iint.c
 create mode 100644 security/integrity/integrity.h

Mimi

