Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0GZTSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 15:18:24 -0400
Received: from kroah.org ([198.145.64.141]:59082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0GZTSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 15:18:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] sysfs: allow creating symlinks from untagged to tagged directories
Date: Mon, 26 Jul 2010 12:18:17 -0700
Message-Id: <1280171897-13157-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100726190905.GC12683@kroah.com>
References: <20100726190905.GC12683@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Supporting symlinks from untagged to tagged directories is reasonable,
and needed to support CONFIG_SYSFS_DEPRECATED.  So don't fail a prior
allowing that case to work.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/symlink.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 6603833..a7ac78f 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -67,7 +67,8 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 
 	sysfs_addrm_start(&acxt, parent_sd);
 	/* Symlinks must be between directories with the same ns_type */
-	if (ns_type == sysfs_ns_type(sd->s_symlink.target_sd->s_parent)) {
+	if (!ns_type ||
+	    (ns_type == sysfs_ns_type(sd->s_symlink.target_sd->s_parent))) {
 		if (warn)
 			error = sysfs_add_one(&acxt, sd);
 		else
-- 
1.7.2

