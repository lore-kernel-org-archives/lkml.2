Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab0JOXdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 19:33:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40047 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0JOXdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 19:33:43 -0400
Date: Fri, 15 Oct 2010 16:32:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>,
        xfs-masters@oss.sgi.com
Subject: [PATCH] fs: move exportfs since it is not a networking filesystem
Message-Id: <20101015163227.3edf2f42.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move the EXPORTFS kconfig symbol out of the NETWORK_FILESYSTEMS block
since it provides a library function that can be (and is) used by other
(non-network) filesystems.

This also eliminates a kconfig dependency warning:

warning: (XFS_FS && BLOCK || NFSD && NETWORK_FILESYSTEMS && INET && FILE_LOCKING && BKL) selects EXPORTFS which has unmet direct dependencies (NETWORK_FILESYSTEMS)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alex Elder <aelder@sgi.com>
Cc: xfs-masters@oss.sgi.com
---
 fs/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- lnx-2636-rc8.orig/fs/Kconfig
+++ lnx-2636-rc8/fs/Kconfig
@@ -47,6 +47,9 @@ source "fs/nilfs2/Kconfig"
 
 endif # BLOCK
 
+config EXPORTFS
+	tristate
+
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EMBEDDED
 	default y
@@ -221,9 +224,6 @@ config LOCKD_V4
 	depends on FILE_LOCKING
 	default y
 
-config EXPORTFS
-	tristate
-
 config NFS_ACL_SUPPORT
 	tristate
 	select FS_POSIX_ACL
