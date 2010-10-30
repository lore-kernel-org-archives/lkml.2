Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0J3VUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:20:50 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11526 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0J3VUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:20:48 -0400
Date: Sat, 30 Oct 2010 23:10:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>,
        Stephen Hemminger <shemminger@vyatta.com>, ulia Lawall <julia@diku.dk>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] SELinux: Do not assign the same value twice to the same
 variable
Message-ID: <alpine.LNX.2.00.1010302306230.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It makes little sense to assign the same value to the same variable twice 
when there is no code inbetween which could have changed the value of that 
variable.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
Untested patch below.

 policydb.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 94f630d..e5a30ff 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1866,7 +1866,6 @@ static int genfs_read(struct policydb *p, void *fp)
 			if (!newc)
 				goto out;
 
-			rc = -ENOMEM;
 			newc->u.name = kmalloc(len + 1, GFP_KERNEL);
 			if (!newc->u.name)
 				goto out;


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

