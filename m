Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab0FKUlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:41:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54590 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab0FKUlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yEJO1jYtsXI2jQtzy1knrvvib7HnysQOmvOqbLLA/d5S+dsliQHBYa9ZGFZibdJVX4
         QuBtf73u+yyn8hXqWNNbNhjbRu81VScVSsjXjtYo429z+YX9DXZL34Fr4s4bwg7yb58Y
         BpwkCmjlcommKLmTBmAysbwWnFuLgfq86YHRA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, zippel@linux-m68k.org,
       linux-fsdevel@vger.kernel.org, rusty@rustcorp.com.au,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/6]kernel:audit.c Fix warning: variable 'nlh' set but not used
Date: Fri, 11 Jun 2010 13:41:05 -0700
Message-Id: <1276288869-16815-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing dead code(hopefully), fixes a warning
when compiling the kernel.

  CC      kernel/audit.o
kernel/audit.c: In function 'audit_buffer_alloc':
kernel/audit.c:1044:19: warning: variable 'nlh' set but not used
  CC      kernel/auditfilter.o
 
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 kernel/audit.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index c71bd26..783d958 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1041,8 +1041,7 @@ static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
 {
 	unsigned long flags;
 	struct audit_buffer *ab = NULL;
-	struct nlmsghdr *nlh;
-
+	
 	spin_lock_irqsave(&audit_freelist_lock, flags);
 	if (!list_empty(&audit_freelist)) {
 		ab = list_entry(audit_freelist.next,
@@ -1065,8 +1064,7 @@ static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
 	if (!ab->skb)
 		goto nlmsg_failure;
 
-	nlh = NLMSG_NEW(ab->skb, 0, 0, type, 0, 0);
-
+	
 	return ab;
 
 nlmsg_failure:                  /* Used by NLMSG_NEW */
-- 
1.7.1.rc1.21.gf3bd6

