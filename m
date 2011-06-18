Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1FRPKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:10:30 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:53905 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1FRPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:10:27 -0400
Date: Sat, 18 Jun 2011 11:10:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Randy Dunlap <rdunlap@xenotime.net>, hughd@google.com,
        Andrew Morton <akpm@osdl.org>
Subject: [PATCH v2] TMPFS: Expand "help" to explain value of
 TMPFS_POSIX_ACL
Message-ID: <alpine.DEB.2.02.1106181108210.3831@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Expand the fs/Kconfig "help" info to clarify why it's a bad idea to
deselect the TMPFS_POSIX_ACL config variable.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/fs/Kconfig b/fs/Kconfig
index 19891aa..4217543 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -127,14 +127,20 @@ config TMPFS_POSIX_ACL
 	select TMPFS_XATTR
 	select GENERIC_ACL
 	help
-	  POSIX Access Control Lists (ACLs) support permissions for users and
-	  groups beyond the owner/group/world scheme.
+	  POSIX Access Control Lists (ACLs) support additional access rights
+	  for users and groups beyond the standard owner/group/world scheme,
+	  and this option selects support for ACLs specifically for tmpfs
+	  filesystems.
+
+	  If you've selected TMPFS, you almost certainly want this option
+	  as well since a number of user space features (e.g., ALSA sound)
+	  require POSIX ACL support under /dev to work properly.  In other
+	  words, if you're not sure and you have no *compelling* reason to
+	  deselect this feature, say Y.

 	  To learn more about Access Control Lists, visit the POSIX ACLs for
 	  Linux website <http://acl.bestbits.at/>.

-	  If you don't know what Access Control Lists are, say N.
-
 config TMPFS_XATTR
 	bool "Tmpfs extended attributes"
 	depends on TMPFS

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
