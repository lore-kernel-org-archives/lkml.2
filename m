Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0CaHlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:41:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42501 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab0CaHlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=k4mj9UKdoxExfScMdiFHqgOQrvlZX2MioTYKi3kXFP4cefP3DCGgIsRlGyOOkLcE8Z
         Tf7dItWRKzVJ382XqE7wmhqaanQ0i+wp5Qga2dP66LbP+RmPBqCMXW4KuJRVnSTXiusB
         Npu5uKlngQU3XN2IMAypE8SkVIQ0WeKohZOtM=
Date: Wed, 31 Mar 2010 15:41:00 +0800
From: Li Hong <lihong.hi@gmail.com>
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
       linux-nilfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: fix a wrong type conversion in nilfs_ioctl()
Message-ID: <20100331074100.GA11787@xhl>
Mail-Followup-To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux xhl 2.6.31-14-generic
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(void * __user *) should be (void __user *)

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 fs/nilfs2/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 313d0a2..c446017 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -648,7 +648,7 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
-	void __user *argp = (void * __user *)arg;
+	void __user *argp = (void __user *)arg;
 
 	switch (cmd) {
 	case NILFS_IOCTL_CHANGE_CPMODE:
-- 
1.6.3.3

