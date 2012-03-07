Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab2CGPLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:11:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10803 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab2CGPLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:11:17 -0500
X-IronPort-AV: E=Sophos;i="4.73,546,1325433600"; 
   d="scan'208";a="4482191"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Eric Paris <eparis@parisplace.org>, James Morris <jmorris@namei.org>,
        sds@tycho.nsa.gov, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] selinux:replace weak GFP_ATOMIC to GFP_KERNEL in avc_add_callback
Date: Wed, 7 Mar 2012 22:17:13 +0800
Message-Id: <1331129834-1554-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.9.2
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 22:16:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 22:17:04,
	Serialize complete at 2012-03-07 22:17:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avc_add_callback now only called from initcalls, so replace the
weak GFP_ATOMIC to GFP_KERNEL, and mark this function __init
to make a warning when not been called from initcalls.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 security/selinux/avc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index dca1c22..c301679 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -557,7 +557,7 @@ int avc_audit(u32 ssid, u32 tsid,
  * @perms based on @tclass.  Returns %0 on success or
  * -%ENOMEM if insufficient memory exists to add the callback.
  */
-int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
+int __init avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
 				     u16 tclass, u32 perms,
 				     u32 *out_retained),
 		     u32 events, u32 ssid, u32 tsid,
@@ -566,7 +566,7 @@ int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
 	struct avc_callback_node *c;
 	int rc = 0;
 
-	c = kmalloc(sizeof(*c), GFP_ATOMIC);
+	c = kmalloc(sizeof(*c), GFP_KERNEL);
 	if (!c) {
 		rc = -ENOMEM;
 		goto out;
-- 
1.7.9.2.323.gf051a

