Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1EHWwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:52:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40833 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab1EHWll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wv+EtkrIognQoxlEQwsHTo4E/DkjzVBXkjyCaHkn9VjYi0/e94GoB8x6h1+Tm/bWV3
         X+f+oDtT7QNSkIdVRUm8ZoxMuLYkrUfgaknfJ1GsWSdi3PIc3vU7OvOBJV5TcWJpZrmM
         KwKDkD2Kmh69zhNBcQWzXOU166pWbzaavsf0g=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 063/115] sysctl: simplify find_in_table
Date: Mon,  9 May 2011 00:39:15 +0200
Message-Id: <1304894407-32201-64-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if (!p->procname) check is useless because the loop condition
prevents it from happening.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/proc/proc_sysctl.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f50133c..d1640bc 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -52,18 +52,12 @@ static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 	int len;
 	for ( ; p->procname; p++) {
 
-		if (!p->procname)
-			continue;
-
 		len = strlen(p->procname);
 		if (len != name->len)
 			continue;
 
-		if (memcmp(p->procname, name->name, len) != 0)
-			continue;
-
-		/* I have a match */
-		return p;
+		if (memcmp(p->procname, name->name, len) == 0)
+			return p;
 	}
 	return NULL;
 }
-- 
1.7.5.134.g1c08b

