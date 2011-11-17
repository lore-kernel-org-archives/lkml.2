Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1KRJcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:32:46 -0500
Received: from www17.your-server.de ([213.133.104.17]:34738 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1KRJcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:32:43 -0500
Subject: [PATCH] selinux: Casting (void *) value returned by kmalloc is
 useless
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.261.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
--- a/security/selinux/ss/conditional.c 2011-11-07 19:38:36.047349083 +0100
+++ b/security/selinux/ss/conditional.c 2011-11-08 09:16:49.914488441 +0100
@@ -175,7 +175,7 @@ void cond_policydb_destroy(struct policy
 int cond_init_bool_indexes(struct policydb *p)
 {
 	kfree(p->bool_val_to_struct);
-	p->bool_val_to_struct = (struct cond_bool_datum **)
+	p->bool_val_to_struct =
 		kmalloc(p->p_bools.nprim * sizeof(struct cond_bool_datum *), GFP_KERNEL);
 	if (!p->bool_val_to_struct)
 		return -ENOMEM;
