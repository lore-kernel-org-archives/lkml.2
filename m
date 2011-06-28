Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1F1HMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:12:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55640 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab1F1HKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ooz3aw4guBAfXIXtf+vJBvkSlp4g36Ad7yzrCklY5OdLgduidc1VyOiw37y6QLHkP4
         /+Ce+W+tEf8gr2VXjeDMFDURkbOMumPEg/EUobT2yLJZcJjlOPDebp6SE/I9LmhuMtp+
         gjI+PwWII3kV1qwKqqehHSJ3Vc4P0CfijfawM=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 06/11] dynamic_debug: KERN_ERR should not depend upon verbosity
Date: Tue, 28 Jun 2011 01:09:47 -0600
Message-Id: <1309244992-2305-7-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

issue keyword/parsing errors even w/o verbose set;
uncover otherwize mysterious non-functionality.
Also convert to pr_err(), which supplies __func__ via pr_fmt.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 17bace8..7cf5fa7 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -343,9 +343,7 @@ static int ddebug_parse_query(char *words[], int nwords,
 				query->last_lineno = query->first_lineno;
 			}
 		} else {
-			if (verbose)
-				printk(KERN_ERR "%s: unknown keyword \"%s\"\n",
-					__func__, words[i]);
+			pr_err("unknown keyword \"%s\"\n", words[i]);
 			return -EINVAL;
 		}
 	}
-- 
1.7.4.1

