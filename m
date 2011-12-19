Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1LSWNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:13:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1LSWNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:13:08 -0500
Date: Mon, 19 Dec 2011 17:13:03 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <cda19a348ff2b35c7bd9b60584174396d0ec2b2b.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 12/16] dynamic_debug: chop off comments in ddebug_tokenize
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

If a token begins with #, the remainder of query string is a comment,
so drop it.  Doing it here avoids '#' in quoted strings.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 4be55d8..86a9abb 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -183,6 +183,8 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 		buf = skip_spaces(buf);
 		if (!*buf)
 			break;	/* oh, it was trailing whitespace */
+		if (*buf == '#')
+			break;	/* token starts comment, skip rest of line */
 
 		/* find `end' of word, whitespace separated or quoted */
 		if (*buf == '"' || *buf == '\'') {
-- 
1.7.7.3

