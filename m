Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1FBQA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 12:00:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55153 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1FBQAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 12:00:55 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH] sysctl: remove impossible condition check
Date: Thu,  2 Jun 2011 13:00:44 -0300
Message-Id: <1307030444-7095-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <BANLkTimu68E0_U0w8XAtLQztHY6vJqkPVQ@mail.gmail.com>
References: <BANLkTimu68E0_U0w8XAtLQztHY6vJqkPVQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 fs/proc/proc_sysctl.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f50133c..6cbcb1e 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -49,17 +49,11 @@ out:
 
 static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 {
-	int len;
 	for ( ; p->procname; p++) {
-
-		if (!p->procname)
-			continue;
-
-		len = strlen(p->procname);
-		if (len != name->len)
+		if (strlen(p->procname) != name->len)
 			continue;
 
-		if (memcmp(p->procname, name->name, len) != 0)
+		if (memcmp(p->procname, name->name, name->len) != 0)
 			continue;
 
 		/* I have a match */
@@ -223,10 +217,6 @@ static int scan(struct ctl_table_header *head, ctl_table *table,
 	for (; table->procname; table++, (*pos)++) {
 		int res;
 
-		/* Can't do anything without a proc name */
-		if (!table->procname)
-			continue;
-
 		if (*pos < file->f_pos)
 			continue;
 
-- 
1.7.5.2

