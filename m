Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319Ab0EUQyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:54:51 -0400
Received: from kroah.org ([198.145.64.141]:39126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934252Ab0EUQy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/38] sysfs: Remove double free sysfs_get_sb
Date: Fri, 21 May 2010 09:53:49 -0700
Message-Id: <1274460848-11377-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/mount.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index db0b1f2..50e4fb6 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -104,7 +104,6 @@ static int sysfs_get_sb(struct file_system_type *fs_type,
 	if (IS_ERR(sb) || sb->s_fs_info != info)
 		kfree(info);
 	if (IS_ERR(sb)) {
-		kfree(info);
 		error = PTR_ERR(sb);
 		goto out;
 	}
-- 
1.7.0.3

