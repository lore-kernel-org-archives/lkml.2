Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab2BNQgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:36:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40376 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2BNQgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:36:10 -0500
Message-ID: <1329237367.2293.17.camel@twins>
Subject: [PATCH] sysfs: Remove CPP abuse
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 14 Feb 2012 17:36:07 +0100
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's absolutely no reason to abuse CPP to shorten a common sub
expression, C has variables for this.


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/sysfs/dir.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7fdf6a7..80fb6e6 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -576,8 +576,11 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 	}
 
 	while (p) {
+		struct sysfs_dirent *node;
 		int c;
-#define node	rb_entry(p, struct sysfs_dirent, name_node)
+	       
+		node = rb_entry(p, struct sysfs_dirent, name_node);
+
 		c = strcmp(name, node->s_name);
 		if (c < 0) {
 			p = node->name_node.rb_left;
@@ -587,7 +590,6 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 			found = node;
 			p = node->name_node.rb_left;
 		}
-#undef node
 	}
 
 	if (found) {

