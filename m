Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2DPQRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:17:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab2DPQOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:25 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <val@vaaconsulting.com>,
        Kamal Mostafa <kamal@canonical.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 27/27] Documentation: Correct s_umount state for freeze_fs/unfreeze_fs
Date: Mon, 16 Apr 2012 18:14:05 +0200
Message-Id: <1334592845-22862-28-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <val@vaaconsulting.com>

freeze_fs/unfreeze_fs ops are called with s_umount held for write, not read.

Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/Locking |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 4fca82e..406fb09 100644
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
1.7.1

