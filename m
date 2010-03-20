Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0CTLY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:24:27 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34531 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0CTLY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=TCx+b9AT6AiObAIxP/p2165O06IqCyx14vOCQXx7XIwgWyRwZBNVbOaQZkZtTtb1PY
         CcK1fxUk+dM07UJUsXQtxSV/s5DTxS/qB7Swvw0A8oU7lGH3x/EZ6jTJGiCT6XIkY9ld
         cStoPTTGqf7bTNg3z4TU1GLSy686Eg0BsmqN8=
Date: Sat, 20 Mar 2010 14:24:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
       Sage Weil <sage@newdream.net>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch 2/3] btrfs: handle kmalloc() failure
Message-ID: <20100320112415.GW5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Sage Weil <sage@newdream.net>, Al Viro <viro@zeniv.linux.org.uk>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM if kmalloc() fails.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 15f661d..be9b5df 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1212,6 +1212,9 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
 		return -EPERM;
 
 	args = kmalloc(sizeof(*args), GFP_KERNEL);
+	if (!args)
+		return -ENOMEM;
+
 	if (copy_from_user(args, argp, sizeof(*args))) {
 		kfree(args);
 		return -EFAULT;
