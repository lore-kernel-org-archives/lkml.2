Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3AFPtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 10:49:06 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53055 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab3AFPtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 10:49:04 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 06 Jan 2013 09:49:02 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] namei.h: Include errno.h
Date: Sun,  6 Jan 2013 07:48:49 -0800
Message-Id: <1357487329-32034-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b9d6ba94 (vfs: add a retry_estale helper function to handle retries
on ESTALE) intruduced the use of ESTALE in namei.h. Since namei.h does not
include errno.h, this results in the following build error for callers/users
which do not include errno.h directly.

include/linux/namei.h:114:19: error: 'ESTALE' undeclared (first use in this
function)

Add the missing include.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/namei.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/namei.h b/include/linux/namei.h
index e998c03..92313e4 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -4,6 +4,7 @@
 #include <linux/dcache.h>
 #include <linux/linkage.h>
 #include <linux/path.h>
+#include <linux/errno.h>
 
 struct vfsmount;
 
-- 
1.7.9.7

