Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2DKJVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:21:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097Ab2DKJVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:21:33 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Poirier <bpoirier@suse.de>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: use depends instead of select in kconfig
Date: Wed, 11 Apr 2012 09:56:52 +0100
Message-Id: <1334134614-19805-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1334134614-19805-1-git-send-email-swhiteho@redhat.com>
References: <1334134614-19805-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>

Avoids having to duplicate the dependencies of what is 'select'ed (and on
down...)

Those dependencies are currently incomplete, leading to broken builds with
GFS2_FS_LOCKING_DLM=y and IP_SCTP=n.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index c465ae0..eb08c9e 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -1,10 +1,6 @@
 config GFS2_FS
 	tristate "GFS2 file system support"
 	depends on (64BIT || LBDAF)
-	select DLM if GFS2_FS_LOCKING_DLM
-	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
-	select SYSFS if GFS2_FS_LOCKING_DLM
-	select IP_SCTP if DLM_SCTP
 	select FS_POSIX_ACL
 	select CRC32
 	select QUOTACTL
@@ -29,7 +25,8 @@ config GFS2_FS
 
 config GFS2_FS_LOCKING_DLM
 	bool "GFS2 DLM locking"
-	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && HOTPLUG
+	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
+		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
 	help
 	  Multiple node locking module for GFS2
 
-- 
1.7.4

