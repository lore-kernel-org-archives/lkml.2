Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1LSWMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:12:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1LSWMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:12:39 -0500
Date: Mon, 19 Dec 2011 17:12:34 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <42bb22b0b937cf4f3458b7c08b0294e38f1aa778.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 06/16] dynamic_debug: pr_err() call should not depend upon verbosity
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Issue keyword/parsing errors even w/o verbose set;
uncover otherwize mysterious non-functionality.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 6fc8622..d232025 100644
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

