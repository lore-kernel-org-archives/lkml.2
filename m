Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1K3UBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:01:44 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46897 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1K3T5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:57:35 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 07/25] dynamic_debug: pr_err() call should not depend upon verbosity
Date: Wed, 30 Nov 2011 12:56:36 -0700
Message-Id: <1322683014-13285-8-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

issue keyword/parsing errors even w/o verbose set;
uncover otherwize mysterious non-functionality.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 101e2e5..4c6d0b7 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -322,8 +322,7 @@ static int ddebug_parse_query(char *words[], int nwords,
 				query->last_lineno = query->first_lineno;
 			}
 		} else {
-			if (verbose)
-				pr_err("unknown keyword \"%s\"\n", words[i]);
+			pr_err("unknown keyword \"%s\"\n", words[i]);
 			return -EINVAL;
 		}
 	}
-- 
1.7.7.3

