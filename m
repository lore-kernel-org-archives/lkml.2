Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2LMNs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:48:58 -0500
Received: from web25.pochta.ru ([62.141.94.205]:36981 "EHLO web25.pochta.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab2LMNs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:48:57 -0500
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2012 08:48:56 EST
From: tux2002@front.ru
To: linux-kernel@vger.kernel.org
Subject: [PATCH] subsystem: proc filesystem
Date: Thu, 13 Dec 2012 17:15:44 +0400
Message-Id: <fd65ffe19c664aff3266d7082240abdd3d1efc54@mail.qip.ru>
X-Priority: 3
X-QIP-Sender: 95.106.185.12
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-NoSpam-Exim-Host: 62.141.94.133
X-NoSpam-Exim-Port: 8092
X-NoSpam-Exim-Scanned: Yes
X-NoSpam-Exim-Result: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patch strengthens file permissions of pid record in proc filesystem. When pid and pidentry records created, his permissions strengthens by creator umask.



./scripts/get_maintainer.pl: No supported VCS found.  Add --nogit to options?

Using a git repository produces better results.

Try Linus Torvalds' latest git repository using:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

linux-kernel@vger.kernel.org (open list)





---

--- linux-3.7/fs/proc/base.c.orig	2012-12-11 06:30:57.000000000 +0300

+++ linux-3.7/fs/proc/base.c	2012-12-13 16:48:59.000000000 +0300

@@ -2035,6 +2035,7 @@ static struct dentry *proc_pident_instan

 

 	ei = PROC_I(inode);

 	inode->i_mode = p->mode;

+	inode->i_mode &= ~(mode_t) get_current()->fs->umask;

 	if (S_ISDIR(inode->i_mode))

 		set_nlink(inode, 2);	/* Use getattr to fix if necessary */

 	if (p->iop)

@@ -2856,7 +2857,8 @@ static struct dentry *proc_pid_instantia

 	if (!inode)

 		goto out;

 

-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;

+	inode->i_mode = S_IFDIR|S_IRUGO|S_IWUSR|S_IXUGO;

+	inode->i_mode &= ~(mode_t) get_current()->fs->umask;

 	inode->i_op = &proc_tgid_base_inode_operations;

 	inode->i_fop = &proc_tgid_base_operations;

 	inode->i_flags|=S_IMMUTABLE;

---
