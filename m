Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2ALClm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:41:42 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54644 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2ALCll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:41:41 -0500
X-AuditID: b753bd60-a2688ba000000655-ac-4f0e48624c9d
X-AuditID: b753bd60-a2688ba000000655-ac-4f0e48624c9d
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH] xfs: show uuid when mount fails due to duplicate uuid
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Date: Thu, 12 Jan 2012 11:47:20 +0900
Message-ID: <20120112024720.3952.73517.stgit@ltc219.sdl.hitachi.co.jp>
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
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
---

 fs/xfs/xfs_mount.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d06afbc..6b96d6e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -158,7 +158,10 @@ xfs_uuid_mount(
 
  out_duplicate:
 	mutex_unlock(&xfs_uuid_table_mutex);
-	xfs_warn(mp, "Filesystem has duplicate UUID - can't mount");
+	xfs_warn(mp,
+		"Filesystem has duplicate UUID - can't mount: uuid = %pU",
+		uuid);
+
 	return XFS_ERROR(EINVAL);
 }
 

