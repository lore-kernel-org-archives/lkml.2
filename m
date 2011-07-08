Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1GHFED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab1GHFD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:59 2011
Message-Id: <20110708001659.090835627@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [065/107] nfsd: v4 support requires CRYPTO
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit be1f4084b4824301e640e81d63b6275cd99ee6a1 upstream.

nfsd V4 support uses crypto interfaces, so select CRYPTO
to fix build errors in 2.6.39:

ERROR: "crypto_destroy_tfm" [fs/nfsd/nfsd.ko] undefined!
ERROR: "crypto_alloc_base" [fs/nfsd/nfsd.ko] undefined!

Reported-by: Wakko Warner <wakko@animx.eu.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -82,6 +82,7 @@ config NFSD_V4
 	select NFSD_V3
 	select FS_POSIX_ACL
 	select SUNRPC_GSS
+	select CRYPTO
 	help
 	  This option enables support in your system's NFS server for
 	  version 4 of the NFS protocol (RFC 3530).


