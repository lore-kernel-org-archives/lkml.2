Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab0KRUdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:33:04 -0500
Received: from xenotime.net ([72.52.115.56]:35031 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757021Ab0KRUdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:33:02 -0500
Date: Thu, 18 Nov 2010 12:27:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: Dan Carpenter <error27@gmail.com>
Cc: Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 2/7] Documentation: make configfs example code simpler, clearer
Message-ID: <1290112054983@xenotime.net>
In-Reply-To: <12901120542939@xenotime.net>
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

--- linux-2.6.37-rc2-git4.orig/Documentation/filesystems/configfs/configfs_example_explicit.c
+++ linux-2.6.37-rc2-git4/Documentation/filesystems/configfs/configfs_example_explicit.c
@@ -89,7 +89,7 @@ static ssize_t childless_storeme_write(s
 	char *p = (char *) page;
 
 	tmp = simple_strtoul(p, &p, 10);
-	if (!p || (*p && (*p != '\n')))
+	if ((*p != '\0') && (*p != '\n'))
 		return -EINVAL;
 
 	if (tmp > INT_MAX)


-- 

