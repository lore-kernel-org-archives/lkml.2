Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab1JNNnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:43:20 -0400
Received: from mga07.intel.com ([143.182.124.22]:48674 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753528Ab1JNNnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:43:13 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        herbert@gondor.hengli.com.au
Subject: [PATCH v2.1 3/7] crypto: GnuPG based MPI lib - make files (part 3)
Date: Fri, 14 Oct 2011 16:45:21 +0300
Message-Id: <2934572c0461726bdbcb30552f90b9caf5823cae.1318598705.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1318598705.git.dmitry.kasatkin@intel.com>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1318598705.git.dmitry.kasatkin@intel.com>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the multi-precision-integer maths library which was originally taken
from GnuPG and ported to the kernel by (among others) David Howells.
This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
The difference is that checkpatch reported errors and warnings have been fixed.

This library is used to implemenet RSA digital signature verification
used in IMA/EVM integrity protection subsystem.

Due to patch size limitation, the patch is divided into 4 parts.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 lib/Kconfig      |    7 +++++++
 lib/Makefile     |    2 ++
 lib/mpi/Makefile |   22 ++++++++++++++++++++++
 3 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 lib/mpi/Makefile

diff --git a/lib/Kconfig b/lib/Kconfig
index 6c695ff..f69ce08 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -279,4 +279,11 @@ config CORDIC
 config LLIST
 	bool
 
+config MPILIB
+	tristate "Multiprecision maths library"
+	help
+	  Multiprecision maths library from GnuPG.
+	  It is used to implement RSA digital signature verification,
+	  which is used by IMA/EVM digital signature extension.
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index d5d175c..97705ae 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -117,6 +117,8 @@ obj-$(CONFIG_CORDIC) += cordic.o
 
 obj-$(CONFIG_LLIST) += llist.o
 
+obj-$(CONFIG_MPILIB) += mpi/
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/mpi/Makefile b/lib/mpi/Makefile
new file mode 100644
index 0000000..0c1c6c3
--- /dev/null
+++ b/lib/mpi/Makefile
@@ -0,0 +1,22 @@
+#
+# MPI multiprecision maths library (from gpg)
+#
+
+obj-$(CONFIG_MPILIB) = mpi.o
+
+mpi-y = \
+	generic_mpih-lshift.o		\
+	generic_mpih-mul1.o		\
+	generic_mpih-mul2.o		\
+	generic_mpih-mul3.o		\
+	generic_mpih-rshift.o		\
+	generic_mpih-sub1.o		\
+	generic_mpih-add1.o		\
+	mpicoder.o			\
+	mpi-bit.o			\
+	mpih-cmp.o			\
+	mpih-div.o			\
+	mpih-mul.o			\
+	mpi-pow.o			\
+	mpiutil.o
+
-- 
1.7.4.1

