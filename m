Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2DMNiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:38:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19865 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2DMNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:38:08 -0400
Date: Fri, 13 Apr 2012 16:37:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] c/r: ipc: uninitialized variable in compat_do_msg_fill()
Message-ID: <20120413133751.GA26645@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F882C39.0122,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never initialize "msgp".  It's unfortunate that GCC doesn't warn
about this.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/ipc/compat.c b/ipc/compat.c
index 6da376b..0c2ebd0 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -363,7 +363,7 @@ static long compat_do_msg_steal(void __user *dest, struct msg_msg *msg, size_t b
 
 long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
-	struct compat_msgbuf __user *msgp;
+	struct compat_msgbuf __user *msgp = dest;
 	size_t msgsz;
 
 	if (put_user(msg->m_type, &msgp->mtype))
