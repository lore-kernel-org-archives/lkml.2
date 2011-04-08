Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1DHJDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:03:45 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:42058 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1DHJDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:03:44 -0400
Subject: [PATCH] selinux: downgrade two printks to KERN_DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 08 Apr 2011 11:03:27 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 (3.0.0-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1302253422.7787.2.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent (Fedora Rawhide) selinux policy update triggers this error:
    filename_trans_read: nel=0

But there seems to be no reason why filename_trans_read() prints this
message (and a similar message) at KERN_ERR level. So downgrade it to
KERN_DEBUG level.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only.

 security/selinux/ss/policydb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index e7b850a..8e9cc8d10 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1819,7 +1819,7 @@ static int filename_trans_read(struct policydb *p, void *fp)
 		goto out;
 	nel = le32_to_cpu(buf[0]);
 
-	printk(KERN_ERR "%s: nel=%d\n", __func__, nel);
+	printk(KERN_DEBUG "%s: nel=%d\n", __func__, nel);
 
 	last = p->filename_trans;
 	while (last && last->next)
@@ -1857,7 +1857,7 @@ static int filename_trans_read(struct policydb *p, void *fp)
 			goto out;
 		name[len] = 0;
 
-		printk(KERN_ERR "%s: ft=%p ft->name=%p ft->name=%s\n", __func__, ft, ft->name, ft->name);
+		printk(KERN_DEBUG "%s: ft=%p ft->name=%p ft->name=%s\n", __func__, ft, ft->name, ft->name);
 
 		rc = next_entry(buf, fp, sizeof(u32) * 4);
 		if (rc)
-- 
1.7.4.2



