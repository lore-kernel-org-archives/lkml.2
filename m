Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab0FDUtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:49:22 -0400
Received: from kroah.org ([198.145.64.141]:44037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab0FDUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/11] vt_ioctl: return -EFAULT on copy_from_user errors
Date: Fri,  4 Jun 2010 13:47:56 -0700
Message-Id: <1275684477-20172-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

copy_from_user() returns the number of bytes remaining but we want to
return a negative error code here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt_ioctl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 6aa1028..cb19dbc 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1303,7 +1303,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		if (!perm)
 			goto eperm;
 		ret = copy_from_user(&ui, up, sizeof(struct unimapinit));
-		if (!ret)
+		if (ret)
+			ret = -EFAULT;
+		else
 			con_clear_unimap(vc, &ui);
 		break;
 	      }
-- 
1.7.1

