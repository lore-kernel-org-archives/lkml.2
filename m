Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0GZTSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 15:18:39 -0400
Received: from kroah.org ([198.145.64.141]:59078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0GZTSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 15:18:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] sysfs: sysfs_delete_link handle symlinks from untagged to tagged directories.
Date: Mon, 26 Jul 2010 12:18:16 -0700
Message-Id: <1280171897-13157-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100726190905.GC12683@kroah.com>
References: <20100726190905.GC12683@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This happens for network devices when SYSFS_DEPRECATED is enabled.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/symlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 44bca5f..6603833 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -135,7 +135,7 @@ void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
 {
 	const void *ns = NULL;
 	spin_lock(&sysfs_assoc_lock);
-	if (targ->sd)
+	if (targ->sd && sysfs_ns_type(kobj->sd))
 		ns = targ->sd->s_ns;
 	spin_unlock(&sysfs_assoc_lock);
 	sysfs_hash_and_remove(kobj->sd, ns, name);
-- 
1.7.2

