Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab1LEU4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:56:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab1LEUzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:55:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Matthew Wilcox <matthew@wil.cx>, Randy Dunlap <rdunlap@xenotime.net>,
        Theodore Tso <tytso@mit.edu>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Surbhi Palande <csurbhi@gmail.com>,
        Valerie Aurora <val@vaaconsulting.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/5 resend] Documentation: Correct s_umount state for freeze_fs/unfreeze_fs
Date: Mon,  5 Dec 2011 12:54:49 -0800
Message-Id: <1323118489-16326-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323118489-16326-1-git-send-email-kamal@canonical.com>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <val@vaaconsulting.com>

freeze_fs/unfreeze_fs ops are called with s_umount held for write, not read.

BugLink: https://bugs.launchpad.net/bugs/897421
Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/filesystems/Locking |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index d819ba1..7e46a94 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -134,8 +134,8 @@ evict_inode:
 put_super:		write
 write_super:		read
 sync_fs:		read
-freeze_fs:		read
-unfreeze_fs:		read
+freeze_fs:		write
+unfreeze_fs:		write
 statfs:			maybe(read)	(see below)
 remount_fs:		write
 umount_begin:		no
-- 
1.7.5.4

