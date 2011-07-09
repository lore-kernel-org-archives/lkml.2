Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1GIG6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:58:48 -0400
Received: from gw.minian.org ([83.96.227.91]:36241 "EHLO lab.minian.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751935Ab1GIG6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:58:47 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jul 2011 02:58:47 EDT
From: Edwin van Vliet <edwin@cheatah.nl>
To: dhowells@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Edwin van Vliet <edwin@cheatah.nl>
Subject: [PATCH] kernel/cred: Fix bug on cred reference count
Date: Sat,  9 Jul 2011 08:49:01 +0200
Message-Id: <1310194141-18700-1-git-send-email-edwin@cheatah.nl>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above states that the old obj ref and subj ref should BOTH be
released. However, the line is repeated so the old obj ref is released twice
yet the subj ref is not. So either the comment is wrong, or this is simpy a
bug. Releasing the same ref twice seems wrong in any case.

Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
---
 kernel/cred.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 174fa84..2492f08 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -537,7 +537,7 @@ int commit_creds(struct cred *new)
 
 	/* release the old obj and subj refs both */
 	put_cred(old);
-	put_cred(old);
+	put_cred(new);
 	return 0;
 }
 EXPORT_SYMBOL(commit_creds);
-- 
1.7.5.4

