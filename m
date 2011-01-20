Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1ATScI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:32:08 -0500
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:48603 "EHLO
	homiemail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753382Ab1ATScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:32:06 -0500
Subject: [PATCH 1/3] selinux: return -ENOMEM when memory allocation fails
From: Davidlohr Bueso <dave@gnu.org>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 15:31:58 -0300
Message-ID: <1295548318.2089.11.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 security/selinux/ss/conditional.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index c3f845c..a533732 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -178,7 +178,7 @@ int cond_init_bool_indexes(struct policydb *p)
 	p->bool_val_to_struct = (struct cond_bool_datum **)
 		kmalloc(p->p_bools.nprim * sizeof(struct cond_bool_datum *), GFP_KERNEL);
 	if (!p->bool_val_to_struct)
-		return -1;
+		return -ENOMEM;
 	return 0;
 }
 
-- 
1.7.1





