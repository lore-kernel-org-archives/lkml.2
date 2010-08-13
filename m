Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585Ab0HMQGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 12:06:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51447 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0HMQGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 12:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BQrpyV//S+H+nljhMvhIp/ncupXToP/cyXYh9I/QqAjbv2aByCM2e7P7Bvuj/ZLmXR
         axjV7cwdXqaNaHgsRvQxYnYhAnehQ/AAdPSh5AlAlEav4Bs0I/z3bI4hdOICfkWXD0cg
         W+ijhvIJJs4lB57He5APdxTq5kS580HI4gqWw=
From: Namhyung Kim <namhyung@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] add __user markup in copy_user_handle_tail()
Date: Sat, 14 Aug 2010 01:06:44 +0900
Message-Id: <1281715604-5174-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get/put_user_nocheck() requires 2nd arg should be a user pointer but was missing
__user markup. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/lib/usercopy_64.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index b7c2849..84b0c1b 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -170,14 +170,17 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 	unsigned zero_len;
 
 	for (; len; --len) {
-		if (__get_user_nocheck(c, from++, sizeof(char)))
+		if (__get_user_nocheck(c, (u8 __user __force *) from++,
+				       sizeof(char)))
 			break;
-		if (__put_user_nocheck(c, to++, sizeof(char)))
+		if (__put_user_nocheck(c, (u8 __user __force *) to++,
+				       sizeof(char)))
 			break;
 	}
 
 	for (c = 0, zero_len = len; zerorest && zero_len; --zero_len)
-		if (__put_user_nocheck(c, to++, sizeof(char)))
+		if (__put_user_nocheck(c, (u8 __user __force *) to++,
+				       sizeof(char)))
 			break;
 	return len;
 }
-- 
1.7.0.4

