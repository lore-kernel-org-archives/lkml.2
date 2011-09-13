Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1IMOSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:18:46 -0400
Received: from mga05.intel.com ([192.55.52.89]:59423 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754031Ab1IMOSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:18:43 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        herbert@gondor.hengli.com.au
Subject: [RFC v2.1 3/6] crypto: GnuPG based MPI lib - make files needed for ksign
Date: Tue, 13 Sep 2011 17:20:10 +0300
Message-Id: <01cf591b5e8cf6cdfac854ceb6109b6a6179e823.1315921427.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1315921427.git.dmitry.kasatkin@intel.com>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1315921427.git.dmitry.kasatkin@intel.com>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the multi-precision-integer maths library which was originally taken
from GnuPG and ported to the kernel by (among others) David Howells.
This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
The difference is that checkpatch reported errors and warning has been fixed.

This library is used to implemenet RSA digital signature verification
used in IMA/EVM integrity protection subsystem.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 crypto/Kconfig      |    6 ++++++
 crypto/Makefile     |    1 +
 crypto/mpi/Makefile |   20 ++++++++++++++++++++
 3 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 crypto/mpi/Makefile

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ae27b753..4b1b9a4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -857,6 +857,12 @@ config CRYPTO_USER_API_SKCIPHER
 	  This option enables the user-spaces interface for symmetric
 	  key cipher algorithms.
 
+config CRYPTO_MPILIB
+	bool "Multiprecision maths library (EXPERIMENTAL)"
+	depends on CRYPTO
+	help
+	  Multiprecision maths library from GnuPG
+
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
diff --git a/crypto/Makefile b/crypto/Makefile
index ce5a813..604006d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -88,6 +88,7 @@ obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
+obj-$(CONFIG_CRYPTO_MPILIB) += mpi/
 
 #
 # generic algorithms and the async_tx api
diff --git a/crypto/mpi/Makefile b/crypto/mpi/Makefile
new file mode 100644
index 0000000..978dc58
--- /dev/null
+++ b/crypto/mpi/Makefile
@@ -0,0 +1,20 @@
+#
+# MPI multiprecision maths library (from gpg)
+#
+
+obj-$(CONFIG_CRYPTO_MPILIB) = \
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

