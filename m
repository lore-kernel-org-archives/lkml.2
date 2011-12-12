Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1LLXR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:17:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1LLXN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:28 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 13/25] dynamic_debug: chop off comments in ddebug_tokenize
Date: Mon, 12 Dec 2011 16:12:39 -0700
Message-Id: <1323731569-20644-13-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

If a token begins with #, the remainder of query string is a comment,
so drop it.  Doing it here avoids '#' in quoted strings.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index aaa29dc..d285bb5 100644
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

