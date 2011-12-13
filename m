Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1LMQXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 11:23:00 -0500
Received: from sh.osrg.net ([192.16.179.4]:57462 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1LMQWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 11:22:41 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/2] nilfs2: unbreak compat ioctl
Date: Wed, 14 Dec 2011 01:13:48 +0900
Message-Id: <1323792829-17395-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323792829-17395-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1323792829-17395-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 14 Dec 2011 01:22:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

I guess commit 828b1c50ae11e6dda68f8dfefe43b74c7182b157 incidentally broke
all other NILFS compat ioctls. make them work again.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@kernel.org> [3.0+]
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 41d6743..3e65427 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -842,6 +842,19 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case FS_IOC32_GETVERSION:
 		cmd = FS_IOC_GETVERSION;
 		break;
+	case NILFS_IOCTL_CHANGE_CPMODE:
+	case NILFS_IOCTL_DELETE_CHECKPOINT:
+	case NILFS_IOCTL_GET_CPINFO:
+	case NILFS_IOCTL_GET_CPSTAT:
+	case NILFS_IOCTL_GET_SUINFO:
+	case NILFS_IOCTL_GET_SUSTAT:
+	case NILFS_IOCTL_GET_VINFO:
+	case NILFS_IOCTL_GET_BDESCS:
+	case NILFS_IOCTL_CLEAN_SEGMENTS:
+	case NILFS_IOCTL_SYNC:
+	case NILFS_IOCTL_RESIZE:
+	case NILFS_IOCTL_SET_ALLOC_RANGE:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
1.7.7.4

