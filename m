Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1LFTMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:12:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52815 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1LFTMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:42 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 13/25] dynamic_debug: chop off comments in ddebug_tokenize
Date: Tue,  6 Dec 2011 12:11:23 -0700
Message-Id: <1323198694-7186-14-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
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

