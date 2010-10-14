Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab0JNEEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:04:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48667 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0JNEEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:04:20 -0400
Date: Wed, 13 Oct 2010 21:01:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: xfs-masters@oss.sgi.com, lkml <linux-kernel@vger.kernel.org>
Cc: Alex Elder <aelder@sgi.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] xfs: eliminate kconfig dependency warning
Message-Id: <20101013210142.9d524535.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (XFS_FS && BLOCK || NFSD && NETWORK_FILESYSTEMS && INET && FILE_LOCKING && BKL) selects EXPORTFS which has unmet direct dependencies (NETWORK_FILESYSTEMS)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/xfs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101013.orig/fs/xfs/Kconfig
+++ linux-next-20101013/fs/xfs/Kconfig
@@ -1,6 +1,6 @@
 config XFS_FS
 	tristate "XFS filesystem support"
-	depends on BLOCK
+	depends on BLOCK && NETWORK_FILESYSTEMS
 	select EXPORTFS
 	help
 	  XFS is a high performance journaling filesystem which originated
