Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2KHUu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:50:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab2KHUuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:50:54 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH cifs-next] fs: cifs: make smb_echo_interval tunable
Date: Thu,  8 Nov 2012 14:50:28 -0600
Message-Id: <1352407828-23339-1-git-send-email-chris.j.arges@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change SMB_ECHO_INTERVAL to make it a module parameter.

BugLink: http://bugs.launchpad.net/bugs/1017622
BugLink: https://bugzilla.samba.org/show_bug.cgi?id=9006

Reported-by: Oliver Dumschat-Hoette <dumschat-hoette@trisinus.de>
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
---
 fs/cifs/cifsfs.c   |    5 +++++
 fs/cifs/cifsglob.h |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5e62f44..25748b3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -82,6 +82,11 @@ MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
 module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
+unsigned short smb_echo_timeout = 60;
+module_param(smb_echo_timeout, ushort, 0644);
+MODULE_PARM_DESC(smb_echo_timeout, "Timeout between two echo requests. "
+				   "Default: 60. Timeout in seconds ");
+
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f5af252..d64dcd3 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -78,8 +78,9 @@
 /*           (max path length + 1 for null) * 2 for unicode    */
 #define MAX_NAME 514
 
-/* SMB echo "timeout" -- FIXME: tunable? */
-#define SMB_ECHO_INTERVAL (60 * HZ)
+/* SMB echo "timeout" */
+extern unsigned short smb_echo_timeout;
+#define SMB_ECHO_INTERVAL (smb_echo_timeout * HZ)
 
 #include "cifspdu.h"
 
-- 
1.7.10.4

