Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0HYJFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:05:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34683 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0HYJFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:05:49 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>
Subject: [REGRESSION PATCH] NFS: let NFS_V4 and NFSD_V4 enforce CRYPTO
Date: Wed, 25 Aug 2010 11:05:19 +0200
Message-Id: <1282727119-8295-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100825084912.GA10293@pengutronix.de>
References: <20100825084912.GA10293@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow up to

	df486a2 (NFS: Fix the selection of security flavours in Kconfig)

which broke (among others) arm/mx1_defconfig.

Moreover let NFS_V4 select RPCSEC_GSS_KRB5 again as it was before
df486a2.  This make the dependency more explicit than relying on the no
prompt + default y if !(NFS_V4 || NFSD_V4).

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 fs/nfs/Kconfig     |    2 ++
 fs/nfsd/Kconfig    |    2 ++
 net/sunrpc/Kconfig |    2 +-
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 6c2aad4..5b9f870 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -63,6 +63,8 @@ config NFS_V3_ACL
 config NFS_V4
 	bool "NFS client support for NFS version 4"
 	depends on NFS_FS
+	select CRYPTO # recursive select: RPCSEC_GSS_KRB5 depends on CRYPTO
+	select RPCSEC_GSS_KRB5
 	help
 	  This option enables support for version 4 of the NFS protocol
 	  (RFC 3530) in the kernel's NFS client.
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 95932f5..3678a16 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -69,6 +69,8 @@ config NFSD_V4
 	depends on NFSD && PROC_FS && EXPERIMENTAL
 	select NFSD_V3
 	select FS_POSIX_ACL
+	select CRYPTO # recursive select: RPCSEC_GSS_KRB5 depends on CRYPTO
+	select RPCSEC_GSS_KRB5
 	help
 	  This option enables support in your system's NFS server for
 	  version 4 of the NFS protocol (RFC 3530).
diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
index 3376d76..6b661e3 100644
--- a/net/sunrpc/Kconfig
+++ b/net/sunrpc/Kconfig
@@ -20,7 +20,7 @@ config SUNRPC_XPRT_RDMA
 config RPCSEC_GSS_KRB5
 	tristate
 	depends on SUNRPC && CRYPTO
-	prompt "Secure RPC: Kerberos V mechanism" if !(NFS_V4 || NFSD_V4)
+	prompt "Secure RPC: Kerberos V mechanism"
 	default y
 	select SUNRPC_GSS
 	select CRYPTO_MD5
-- 
1.7.1

