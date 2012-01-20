Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2ATUf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:35:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab2ATUfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:35:02 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>,
        Surbhi Palande <csurbhi@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, Valerie Aurora <val@vaaconsulting.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 7/8] Documentation: Correct s_umount state for freeze_fs/unfreeze_fs
Date: Fri, 20 Jan 2012 21:34:45 +0100
Message-Id: <1327091686-23177-8-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1327091686-23177-1-git-send-email-jack@suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
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
1.7.1

