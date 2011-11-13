Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab1KMKcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 05:32:25 -0500
Received: from www17.your-server.de ([213.133.104.17]:59971 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1KMKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 05:32:24 -0500
Message-ID: <1321180334.1624.23.camel@localhost.localdomain>
Subject: Re: [PATCH] nilfs2: unbreak compat ioctl
From: Thomas Meyer <thomas@m3y3r.de>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org
Date: Sun, 13 Nov 2011 11:32:14 +0100
In-Reply-To: <20111110.124918.255392182.ryusuke@osrg.net>
References: <1320697117.1396.4.camel@localhost.localdomain>
	 <20111110.124918.255392182.ryusuke@osrg.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 10.11.2011, 12:49 +0900 schrieb Ryusuke Konishi:
> But, this patch looks to prevent compat_sys_ioctl() from handling
> other compatible ioctls that compat_ioctl_check_table function
> detects.  For instance, fiemap (FS_IOC_FIEMAP) is handled via the
> function.
> 
> I think we should only redirect own ioctl commands
> (i.e. NILFS_IOCTL_xxxx) to the nilfs_ioctl() call.

Hello Ryusuke,

something like this?

kind regards
thomas

>From 241cc9e8c7d6b8218d307117b0d4a0dabbe1d94e Mon Sep 17 00:00:00 2001
From: Thomas Meyer <thomas@m3y3r.de>
Date: Mon, 7 Nov 2011 20:59:02 +0100
Subject: [PATCH] nilfs2: unbreak compat ioctl

I guess commit 828b1c50ae11e6dda68f8dfefe43b74c7182b157 incidentally broke
all other NILFS compat ioctls. make them work again.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
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
1.7.7.1


