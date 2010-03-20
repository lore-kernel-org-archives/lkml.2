Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab0CTLZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:25:00 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55527 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0CTLY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=QRLo7/eUJ29LNqGO21wvkW+goGmXqW7rXmBFmkSKfP7AIDhBl8XECjZDJY0pjGbPbb
         /qo4M8XAkfcqCInTttPZFsWKU+VymWLhV67zybrb28KynEj5iwQL6ZELxLg47OG8VP2u
         a7Za+V/UGhQKJRCbpXrWORU9nE3Lum/WbpkJk=
Date: Sat, 20 Mar 2010 14:24:48 +0300
From: Dan Carpenter <error27@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
       Sage Weil <sage@newdream.net>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch 3/3] btrfs: dereferencing freed memory
Message-ID: <20100320112448.GX5331@bicker>
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

The original code dereferenced range on the next line.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index be9b5df..d7ab56c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1378,6 +1378,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 					   sizeof(*range))) {
 				ret = -EFAULT;
 				kfree(range);
+				goto out;
 			}
 			/* compression requires us to start the IO */
 			if ((range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
