Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1DTKF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 06:05:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54899 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab1DTKF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 06:05:56 -0400
Message-ID: <4DAEB030.1070303@cn.fujitsu.com>
Date: Wed, 20 Apr 2011 18:06:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] Btrfs: fix bh leak on __btrfs_open_devices path
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 18:06:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 18:06:27,
	Serialize complete at 2011-04-20 18:06:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'bh' is forgot to release if no error is detected

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b9fb8c..69fc902 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -631,6 +631,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			list_add(&device->dev_alloc_list,
 				 &fs_devices->alloc_list);
 		}
+		brelse(bh);
 		continue;
 
 error_brelse:
-- 
1.7.4.4
