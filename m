Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1KUGO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 01:14:56 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:49794 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752679Ab1KUGOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 01:14:51 -0500
Message-ID: <4EC9EBD2.3040708@xenotime.net>
Date: Sun, 20 Nov 2011 22:12:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH -next] digsig: fix build errors
References: <20111121133936.ae0ecadbf39ae50da6b842d1@canb.auug.org.au>
In-Reply-To: <20111121133936.ae0ecadbf39ae50da6b842d1@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors by adding kconfig dependency on KEYS:

lib/digsig.c:106:16: error: dereferencing pointer to incomplete type
lib/digsig.c:107:11: error: dereferencing pointer to incomplete type
lib/digsig.c:184:14: error: dereferencing pointer to incomplete type
lib/digsig.c:223:3: error: 'key_ref_t' undeclared (first use in this function)
lib/digsig.c:223:13: error: expected ';' before 'kref'
lib/digsig.c:224:3: error: 'kref' undeclared (first use in this function)
lib/digsig.c:224:3: error: implicit declaration of function 'keyring_search'
lib/digsig.c:231:3: error: implicit declaration of function 'request_key'

and after changing lib/Kconfig:
warning: (INTEGRITY_DIGSIG) selects DIGSIG which has unmet direct dependencies (CRYPTO && KEYS)

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 lib/Kconfig                |    4 ++--
 security/integrity/Kconfig |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- next-2011-1121.orig/lib/Kconfig
+++ next-2011-1121/lib/Kconfig
@@ -294,10 +294,10 @@ config MPILIB_EXTRA
 
 config DIGSIG
 	tristate "In-kernel signature checker"
-	depends on CRYPTO
+	depends on CRYPTO && KEYS
 	select MPILIB
 	help
 	  Digital signature verification. Currently only RSA is supported.
-	  Implementation is done using GnuPG MPI library
+	  Implementation is done using GnuPG MPI library.
 
 endmenu
--- next-2011-1121.orig/security/integrity/Kconfig
+++ next-2011-1121/security/integrity/Kconfig
@@ -5,7 +5,7 @@ config INTEGRITY
 
 config INTEGRITY_DIGSIG
 	boolean "Digital signature verification using multiple keyrings"
-	depends on INTEGRITY
+	depends on INTEGRITY && CRYPTO && KEYS
 	default n
 	select DIGSIG
 	help
