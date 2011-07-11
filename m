Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab1GKHtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:49:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab1GKHrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:40 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 15/21] dynamic_debug: describe_flags with '=[ptmfl]*'
Date: Mon, 11 Jul 2011 01:46:50 -0600
Message-Id: <1310370416-6322-16-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe flags in text using =<flag-chars>.  This has better mnemonics
than the current dash-unless-flags, it says "Flags are = <flag-chars>",
and =<flags> is more selective in a grep; '=' will not show up in module
or filenames, nor in line-ranges.

This isnt yet optimal; "grep ' = ' control" reports on a couple dozen
format-strings, this could be avoided by altering describe_flags()
to emit '-' or '_' for empty flags, such that the grep for empty
flags would be '=_'.  TBD.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index d115f52..31ee0fd 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -102,11 +102,10 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	int i;
 
 	BUG_ON(maxlen < 4);
+	*p++ = '=';
 	for (i = 0; i < ARRAY_SIZE(opt_array); ++i)
 		if (dp->flags & opt_array[i].flag)
 			*p++ = opt_array[i].opt_char;
-	if (p == buf)
-		*p++ = '-';
 	*p = '\0';
 
 	return buf;
-- 
1.7.4.1

