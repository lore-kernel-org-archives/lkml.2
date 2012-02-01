Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2BAUZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:25:21 -0500
Received: from mga06.intel.com ([134.134.136.21]:50384 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753300Ab2BAUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:25:20 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: [RFC][PATCH v1 0/2] integrity: module integrity verification
Date: Wed,  1 Feb 2012 22:25:02 +0200
Message-Id: <cover.1328122362.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is another module verification patchset, which is based on the recently
upstreamed digital signature support used by EVM and IMA-appraisal.

The initial module verification code was dependent on IMA-appraisal and
was using security.ima extended attribute to store the signature.
Based on some feeback, it was decided to add the ability to store the
signature in a corresponding module signature file <module>.sig and also
make module checking no longer dependent on IMA-appraisal.
Having signature in a separate <module>.sig file allows to use it on filesystem,
which do not support extended attributes, e.g. network file system,
and also copying modules to target system from build system.

The initial module verification code was dependent on IMA-appraisal and
was using security.ima extended attribute to store the signature.
Based on some feeback it was decided to remove IMA dependency and also
add possibility to store the signature in the corresponding signature
file <module>.sig. It allows to use it on filesystems, which do not support
extended attributes and also allows copying of modules from build system to
the target for testing without extended attribute aware tools.

modprobe and insmod have been modified to read signature either from
extended attribute or signature file and pass it as a kernel module
parameter to load_module system call.

Signature generation is done using the same tool as for EVM/IMA: evm-utils.

These 2 patches are available on the top at #next-ima-module branch at
git://git.kernel.org/pub/scm/linux/kernel/git/kasatkin/linux-digsig.git

evm-utils and module-init-tools are available in linux-ima project GIT:
git://linux-ima.git.sourceforge.net / linux-ima/evm-utils
git://linux-ima.git.sourceforge.net / linux-ima/module-init-tools

- Dmitry

Dmitry Kasatkin (2):
  integrity: add ima_module_check hook
  integrity: verify module integrity based on signature

 Documentation/ABI/testing/securityfs-module-check |   17 ++
 include/linux/integrity.h                         |   10 +
 kernel/module.c                                   |   20 ++-
 security/integrity/Kconfig                        |   11 +
 security/integrity/Makefile                       |    1 +
 security/integrity/module.c                       |  251 +++++++++++++++++++++
 6 files changed, 305 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/ABI/testing/securityfs-module-check
 create mode 100644 security/integrity/module.c

-- 
1.7.5.4

