Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab0JYExl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 00:53:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59367 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0JYExk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 00:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=bHkJf+uZn1KmBTKYPnt7PuCvDnZxXJGreWFi+cPcJmEoSMc8WsvdGh6SY7m+04ecJ5
         r1k0lMUcpuhwVSu9D4/cGsYfgelP3TSMF+/Mo5v0a631/B7h7HO63S9b9cOEmQv2o+2c
         vf6qcYt7H9qOdWVhVPRv8f30KpFayry7v5dIc=
Date: Mon, 25 Oct 2010 06:53:27 +0200
From: Dan Carpenter <error27@gmail.com>
To: Christoph Hellwig <hch@tuxera.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] hfsplus: fix double lock typo in ioctl
Message-ID: <20101025045326.GW5985@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Christoph Hellwig <hch@tuxera.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was supposed to be a mutex_unlock() instead of a mutex_lock().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index 5b4667e..40a85a3 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -92,7 +92,7 @@ static int hfsplus_ioctl_setflags(struct file *file, int __user *user_flags)
 	mark_inode_dirty(inode);
 
 out_unlock_inode:
-	mutex_lock(&inode->i_mutex);
+	mutex_unlock(&inode->i_mutex);
 out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
 out:
