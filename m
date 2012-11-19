Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2KSFl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:41:26 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39324 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2KSF3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:22 -0500
X-Originating-IP: 217.70.178.141
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 11/58] tty: Mark sysfs_attr_ns static
Date: Sun, 18 Nov 2012 21:27:50 -0800
Message-Id: <1353302917-13995-12-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of fs/sysfs/file.c references this function, so mark it static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/sysfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 00012e3..602f56d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -485,8 +485,8 @@ const struct file_operations sysfs_file_operations = {
 	.poll		= sysfs_poll,
 };
 
-int sysfs_attr_ns(struct kobject *kobj, const struct attribute *attr,
-		  const void **pns)
+static int sysfs_attr_ns(struct kobject *kobj, const struct attribute *attr,
+			 const void **pns)
 {
 	struct sysfs_dirent *dir_sd = kobj->sd;
 	const struct sysfs_ops *ops;
-- 
1.7.10.4

