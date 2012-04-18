Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2DRNGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:06:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55361 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2DRNF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:05:58 -0400
Subject: [PULL REQUEST] : ima-appraisal patches
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date: Wed, 18 Apr 2012 09:04:29 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334754302.2137.8.camel@falcor>
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041813-4242-0000-0000-00000161C02A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

As the last IMA-appraisal posting on 3/29 addressed Al's
performance/maintenance concerns of deferring the __fput() and there
hasn't been any additional comments, please consider pulling the
IMA-appraisal patches.

The linux-integrity.git also contains the two prereqs:
   vfs: fix IMA lockdep circular locking dependency  (Acked by Eric)
   vfs: iversion truncate bug fix (currently in linux-next, via Andrew)

The following changes since commit eadc10b3e17f00681f7bfb2ed6e4aee39ad93f03:

  vfs: extend vfs_removexattr locking (2012-04-18 07:06:55 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git next-ima-appraisal

thanks,

Mimi

Dmitry Kasatkin (3):
      ima: free securityfs violations file
      ima: allocating iint improvements
      ima: digital signature verification support

Mimi Zohar (8):
      vfs: move ima_file_free before releasing the file
      ima: integrity appraisal extension
      ima: add appraise action keywords and default rules
      ima: replace iint spinlock with rwlock/read_lock
      ima: add inode_post_setattr call
      ima: add ima_inode_setxattr/removexattr function and calls
      ima: defer calling __fput()
      ima: add support for different security.ima data types

 Documentation/ABI/testing/ima_policy  |   25 ++-
 Documentation/kernel-parameters.txt   |    8 +
 fs/attr.c                             |    2 +
 fs/file_table.c                       |    7 +-
 include/linux/ima.h                   |   32 +++
 include/linux/integrity.h             |    7 +-
 include/linux/xattr.h                 |    3 +
 security/integrity/evm/evm_main.c     |    3 +
 security/integrity/iint.c             |   64 +++----
 security/integrity/ima/Kconfig        |   15 ++
 security/integrity/ima/Makefile       |    2 +
 security/integrity/ima/ima.h          |   37 ++++-
 security/integrity/ima/ima_api.c      |   56 ++++--
 security/integrity/ima/ima_appraise.c |  344 +++++++++++++++++++++++++++++++++
 security/integrity/ima/ima_crypto.c   |    8 +-
 security/integrity/ima/ima_fs.c       |    1 +
 security/integrity/ima/ima_main.c     |   89 ++++++---
 security/integrity/ima/ima_policy.c   |  181 +++++++++++++-----
 security/integrity/integrity.h        |   11 +-
 security/security.c                   |    6 +
 20 files changed, 754 insertions(+), 147 deletions(-)
 create mode 100644 security/integrity/ima/ima_appraise.c


