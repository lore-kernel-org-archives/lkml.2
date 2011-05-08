Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1EHSzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:55:22 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:35894 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab1EHSzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:55:18 -0400
Date: Sun, 8 May 2011 20:44:38 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 13/14] HPFS: Move declaration up, so that there are no
 out-of-scope pointers
Message-ID: <alpine.DEB.2.00.1105082031050.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move declaration up, so that there are no out-of-scope pointers

Reported-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/ea.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/ea.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/ea.c	2011-05-05 01:03:00.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/ea.c	2011-05-05 01:03:01.000000000 +0200
@@ -76,6 +76,7 @@ int hpfs_read_ea(struct super_block *s, 
 	unsigned pos;
 	int ano, len;
 	secno a;
+	char ex[4 + 255 + 1 + 8];
 	struct extended_attribute *ea;
 	struct extended_attribute *ea_end = fnode_end_ea(fnode);
 	for (ea = fnode_ea(fnode); ea < ea_end; ea = next_ea(ea))
@@ -93,7 +94,6 @@ int hpfs_read_ea(struct super_block *s, 
 	ano = fnode->ea_anode;
 	pos = 0;
 	while (pos < len) {
-		char ex[4 + 255 + 1 + 8];
 		ea = (struct extended_attribute *)ex;
 		if (pos + 4 > len) {
 			hpfs_error(s, "EAs don't end correctly, %s %08x, len %08x",
