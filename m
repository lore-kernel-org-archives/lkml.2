Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2ACWlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:41:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab2ACWll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:23 2012
Message-Id: <20120103223323.523042769@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Meyer <thomas@m3y3r.de>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [30/75] nilfs2: unbreak compat ioctl
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Meyer <thomas@m3y3r.de>

commit 695c60f21c69e525a89279a5f35bae4ff237afbc upstream.

commit 828b1c50ae ("nilfs2: add compat ioctl") incidentally broke all
other NILFS compat ioctls.  Make them work again.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/ioctl.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -842,6 +842,19 @@ long nilfs_compat_ioctl(struct file *fil
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


