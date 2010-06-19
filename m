Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0FSRvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 13:51:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39717 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab0FSRvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 13:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=N80G1bkRUitliFXbUwuK+XfM9bzjmF2DYu1MSokk9eSHWzbYdCD2SYWzcyiF5pWPpP
         55LGQnToE78MEbXQTSCVvP/wPSd41c4KvGws++7CLViCROXH1X9c+n83LpHTF3wRl1ZZ
         popIwZTmmydBGoghKL2vdpvg2gO1WCHotftUQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-audit@redhat.com
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/6 v2]kernel:audit.c Fix warning: variable 'nlh' set but not used
Date: Sat, 19 Jun 2010 10:51:40 -0700
Message-Id: <1276969900-11408-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend from the original due to some whitespace issues,
and done incorrectly.
 
The below patch fixes this warning from gcc 4.6.0
  CC      kernel/audit.o
kernel/audit.c: In function 'audit_buffer_alloc':
kernel/audit.c:1044:19: warning: variable 'nlh' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 kernel/audit.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index c71bd26..1d51258 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1041,7 +1041,6 @@ static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
 {
 	unsigned long flags;
 	struct audit_buffer *ab = NULL;
-	struct nlmsghdr *nlh;
 
 	spin_lock_irqsave(&audit_freelist_lock, flags);
 	if (!list_empty(&audit_freelist)) {
@@ -1065,7 +1064,7 @@ static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
 	if (!ab->skb)
 		goto nlmsg_failure;
 
-	nlh = NLMSG_NEW(ab->skb, 0, 0, type, 0, 0);
+	NLMSG_NEW(ab->skb, 0, 0, type, 0, 0);
 
 	return ab;
 
-- 
1.7.1.rc1.21.gf3bd6

