Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1ECUm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:42:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41427 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1ECUm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=OOgyRNES8jtXiEuwl/B0jva7SYkXgXBH11Z7IW7O+DqbZgasIDgiqrqI+Qj1B5kLAh
         Qec8ibG6i+z/vDbZYVxpoftcIaggV5xTZTLtRo16MG2DfzYxbdqYJQHQ38AMM+5N8y26
         1s1xXq3ZJMhc0mMt+ZzpH8jcWKkdjzwEEw+aM=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tim Abbott <tabbott@ksplice.com>, Anders Kaseorg <andersk@ksplice.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] module: Use binary search in lookup_symbol()
Date: Tue,  3 May 2011 22:42:10 +0200
Message-Id: <1304455330-2728-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 kernel/module.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 6a34337..a1f841e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2055,10 +2055,8 @@ static const struct kernel_symbol *lookup_symbol(const char *name,
 	const struct kernel_symbol *stop)
 {
 	const struct kernel_symbol *ks = start;
-	for (; ks < stop; ks++)
-		if (strcmp(ks->name, name) == 0)
-			return ks;
-	return NULL;
+	return bsearch(ks->name, start, stop - start,
+			sizeof(struct kernel_symbol), cmp_name);
 }
 
 static int is_exported(const char *name, unsigned long value,
-- 
1.7.4.1

