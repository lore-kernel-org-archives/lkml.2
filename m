Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab0HTIqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab0HTIqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:30 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 02/19] Add CRYPTO_USERSPACE config option
Date: Fri, 20 Aug 2010 10:45:45 +0200
Message-Id: <1282293963-27807-3-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 crypto/Kconfig            |    5 +++++
 crypto/Makefile           |    2 ++
 crypto/userspace/Makefile |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)
 create mode 100644 crypto/userspace/Makefile

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 81c185a..022768a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -31,6 +31,11 @@ config CRYPTO_FIPS
 	  this is. Note that CRYPTO_ANSI_CPRNG is requred if this
 	  option is selected
 
+config CRYPTO_USERSPACE
+	tristate "User-space crypto API"
+	help
+	  This option provides an user-space API for cryptographic operations.
+
 config CRYPTO_ALGAPI
 	tristate
 	select CRYPTO_ALGAPI2
diff --git a/crypto/Makefile b/crypto/Makefile
index 9e8f619..d284dff 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -90,3 +90,5 @@ obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 #
 obj-$(CONFIG_XOR_BLOCKS) += xor.o
 obj-$(CONFIG_ASYNC_CORE) += async_tx/
+
+obj-$(CONFIG_CRYPTO_USERSPACE) += userspace/
diff --git a/crypto/userspace/Makefile b/crypto/userspace/Makefile
new file mode 100644
index 0000000..b607b90
--- /dev/null
+++ b/crypto/userspace/Makefile
@@ -0,0 +1 @@
+ccflags-y += -I$(src)/libtommath -I$(src)/libtomcrypt/headers -I$(src) -DLTC_SOURCE
-- 
1.7.2.1

