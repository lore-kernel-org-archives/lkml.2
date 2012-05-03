Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab2ECR56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:57:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44226 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2ECR55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:57:57 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: jbaron@redhat.com, Jim Cromie <jim.cromie@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/3] params.c: fix Smack complaint about parse_args
Date: Thu,  3 May 2012 11:57:37 -0600
Message-Id: <1336067860-19953-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 9fb48c744: "params: add 3rd arg to option handler callback
signature", the if-guard added to the pr_debug was overzealous; no
callers pass NULL, and existing code above and below the guard assumes
as much.  Change the if-guard to match, and silence the Smack
complaint.

CC: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/params.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index b60e2c7..be78c90 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -190,7 +190,7 @@ int parse_args(const char *doing,
 	/* Chew leading spaces */
 	args = skip_spaces(args);
 
-	if (args && *args)
+	if (*args)
 		pr_debug("doing %s, parsing ARGS: '%s'\n", doing, args);
 
 	while (*args) {
-- 
1.7.8.1

