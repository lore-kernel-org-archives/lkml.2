Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1FFSXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:23:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36770 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab1FFSXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:23:19 -0400
Date: Mon, 6 Jun 2011 11:22:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Wakko Warner <wakko@animx.eu.org>, linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>
Subject: [PATCH] nfsd: v4 support requires CRYPTO
Message-Id: <20110606112217.9648b8ff.randy.dunlap@oracle.com>
In-Reply-To: <20110603174528.GA1368@animx.eu.org>
References: <20110603174528.GA1368@animx.eu.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4DED1AE7.0159:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

nfsd V4 support uses crypto interfaces, so select CRYPTO
to fix build errors in 2.6.39:

ERROR: "crypto_destroy_tfm" [fs/nfsd/nfsd.ko] undefined!
ERROR: "crypto_alloc_base" [fs/nfsd/nfsd.ko] undefined!

Reported-by: Wakko Warner <wakko@animx.eu.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: stable@kernel.org
---
 fs/nfsd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.39.orig/fs/nfsd/Kconfig
+++ linux-2.6.39/fs/nfsd/Kconfig
@@ -82,6 +82,7 @@ config NFSD_V4
 	select NFSD_V3
 	select FS_POSIX_ACL
 	select SUNRPC_GSS
+	select CRYPTO
 	help
 	  This option enables support in your system's NFS server for
 	  version 4 of the NFS protocol (RFC 3530).
