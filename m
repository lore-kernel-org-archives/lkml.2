Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2DDTjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:39:39 -0400
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:44047 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab2DDTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:39:38 -0400
X-Greylist: delayed 1990 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2012 15:39:37 EDT
Date: Wed, 4 Apr 2012 12:06:20 -0700
From: Tom Goff <thomas.goff@boeing.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] sysfs: Update the name hash for an entry after changing the namespace
Message-ID: <20120404190620.GA8776@boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to allow renaming network devices that have been moved
to another network namespace.

Signed-off-by: Tom Goff <thomas.goff@boeing.com>
---
 fs/sysfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2a7a3f5..8ddc102 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -878,7 +878,6 @@ int sysfs_rename(struct sysfs_dirent *sd,
 
 		dup_name = sd->s_name;
 		sd->s_name = new_name;
-		sd->s_hash = sysfs_name_hash(sd->s_ns, sd->s_name);
 	}
 
 	/* Move to the appropriate place in the appropriate directories rbtree. */
@@ -886,6 +885,7 @@ int sysfs_rename(struct sysfs_dirent *sd,
 	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
 	sd->s_ns = new_ns;
+	sd->s_hash = sysfs_name_hash(sd->s_ns, sd->s_name);
 	sd->s_parent = new_parent_sd;
 	sysfs_link_sibling(sd);
 
-- 
1.7.5.4

