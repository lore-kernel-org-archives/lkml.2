Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0IBSZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:25:45 -0400
Received: from alcalazamora.dti2.net ([81.24.162.8]:3190 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0IBSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:25:44 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2010 14:25:44 EDT
X-MDAV-Processed: alcalazamora.dti2.net, Thu, 02 Sep 2010 20:19:12 +0200
X-Authenticated-Sender: jorge@dti2.net
X-MDRemoteIP: 81.24.161.20
X-Return-Path: prvs=186115afa7=jorge@dti2.net
X-Envelope-From: jorge@dti2.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <4C7FEA9B.70002@dti2.net>
Date: Thu, 02 Sep 2010 20:19:07 +0200
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; es-ES; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Dmitry Monakhov <dmonakhov@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] minix: fix regression in minix_mkdir()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Reply-To: jorge@dti2.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9eed1fb721c6c512795f8847bccc413f3a1143bb broke directory creation on
minix filesystems.

Fix it passing needed mode flag to inode init helper.

Signed-off-by: Jorge Boncompte [DTI2] <jorge@dti2.net>
---
 fs/minix/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index e20ee85..f3f3578 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -115,7 +115,7 @@ static int minix_mkdir(struct inode * dir, struct dentry
*dentry, int mode)

        inode_inc_link_count(dir);

-       inode = minix_new_inode(dir, mode, &err);
+       inode = minix_new_inode(dir, S_IFDIR | mode, &err);
        if (!inode)
                goto out_dir;

-- 
1.7.1

