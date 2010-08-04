Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab0HDBg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:36:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51335 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757858Ab0HDBg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:36:58 -0400
Message-ID: <4C58C557.4090503@cn.fujitsu.com>
Date: Wed, 04 Aug 2010 09:41:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: fix memory leak at umount
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs_info, which is allocated in open_ctree(), should be freed
in close_ctree().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

candidate for stable ?

---
 fs/btrfs/disk-io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 280de15..199cc26 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2469,6 +2469,8 @@ int close_ctree(struct btrfs_root *root)
 	kfree(fs_info->chunk_root);
 	kfree(fs_info->dev_root);
 	kfree(fs_info->csum_root);
+	kfree(fs_info);
+
 	return 0;
 }
 
-- 
1.6.3

