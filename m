Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0KJWn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:43:28 -0500
Received: from xenotime.net ([72.52.115.56]:43595 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757310Ab0KJWnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:43:25 -0500
Date: Wed, 10 Nov 2010 11:53:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>
Cc: Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 2/8] Documentation: make configfs example code simpler, clearer
Message-ID: <12894188301399@xenotime.net>
In-Reply-To: <1289418830794@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

If "p" is NULL then it will cause an oops when we pass it to
simple_strtoul().  In this case "p" can not be NULL so I removed the
check.  I also changed the check a little to make it more explicit that
we are testing whether p points to the NUL char.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
V2: Added some parenthesis to make the precedence more clear.

---
 Documentation/filesystems/configfs/configfs_example_explicit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.37-rc1-git8.orig/Documentation/filesystems/configfs/configfs_example_explicit.c
+++ linux-2.6.37-rc1-git8/Documentation/filesystems/configfs/configfs_example_explicit.c
@@ -89,7 +89,7 @@ static ssize_t childless_storeme_write(s
 	char *p = (char *) page;
 
 	tmp = simple_strtoul(p, &p, 10);
-	if (!p || (*p && (*p != '\n')))
+	if ((*p != '\0') && (*p != '\n'))
 		return -EINVAL;
 
 	if (tmp > INT_MAX)


-- 

