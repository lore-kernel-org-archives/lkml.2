Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1DOC76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 22:59:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab1DOC74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 22:59:56 -0400
Message-ID: <4DA7B56A.6080503@cn.fujitsu.com>
Date: Fri, 15 Apr 2011 11:03:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs: fix FS_IOC_GETFLAGS ioctl
References: <4DA7B559.8060800@cn.fujitsu.com>
In-Reply-To: <4DA7B559.8060800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-15 11:00:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-15 11:00:32,
	Serialize complete at 2011-04-15 11:00:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we've added per file compression/cow support.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3240dd9..aeabf6b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -81,6 +81,13 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
 		iflags |= FS_NOATIME_FL;
 	if (flags & BTRFS_INODE_DIRSYNC)
 		iflags |= FS_DIRSYNC_FL;
+	if (flags & BTRFS_INODE_NODATACOW)
+		iflags |= FS_NOCOW_FL;
+
+	if ((flags & BTRFS_INODE_COMPRESS) && !(flags & BTRFS_INODE_NOCOMPRESS))
+		iflags |= FS_COMPR_FL;
+	else if (flags & BTRFS_INODE_NOCOMPRESS)
+		iflags |= FS_NOCOMP_FL;
 
 	return iflags;
 }
-- 
1.7.3.1
