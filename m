Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab1JGUjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:39:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58642 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab1JGUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:34:16 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 05/26] dynamic_debug: pr_err() call should not depend upon verbosity
Date: Fri,  7 Oct 2011 14:33:11 -0600
Message-Id: <1318019612-20068-6-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

issue keyword/parsing errors even w/o verbose set;
uncover otherwize mysterious non-functionality.
Also convert to pr_err(), which supplies __func__ via pr_fmt.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index a52b78a..e7090f2 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -334,8 +334,7 @@ static int ddebug_parse_query(char *words[], int nwords,
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
1.7.4.4

