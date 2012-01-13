Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2AMFxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 00:53:06 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42215 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2AMFxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 00:53:02 -0500
X-AuditID: b753bd60-a0885ba000000655-74-4f0fc6ba916c
X-AuditID: b753bd60-a0885ba000000655-74-4f0fc6ba916c
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH] xfs: show uuid when mount fails due to duplicate uuid
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Date: Fri, 13 Jan 2012 14:58:39 +0900
Message-ID: <20120113055839.12919.98763.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a system tries to mount a filesystem (FS) using UUID, the xfs
returns -EINVAL and shows a message if a FS with the same UUID has
been already mounted. It is useful to output the duplicate UUID
with it.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
---

 fs/xfs/xfs_mount.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d06afbc..e07f852 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -158,7 +158,7 @@ xfs_uuid_mount(
 
  out_duplicate:
 	mutex_unlock(&xfs_uuid_table_mutex);
-	xfs_warn(mp, "Filesystem has duplicate UUID - can't mount");
+	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
 	return XFS_ERROR(EINVAL);
 }
 

