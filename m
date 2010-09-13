Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0IMVzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:55:44 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:46437 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0IMVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:55:42 -0400
X-Greylist: delayed 2055 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 17:55:42 EDT
Message-ID: <4C8E95D0.9040502@freemail.hu>
Date: Mon, 13 Sep 2010 23:21:20 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, autofs@linux.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] autofs: only declare function when CONFIG_COMPAT is defined
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.187.141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The patch solves tohe following warnings message when CONFIG_COMPAT is not defined:
fs/autofs/root.c:30: warning: ‘autofs_root_compat_ioctl’ declared ‘static’ but never defined

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.36-rc4/fs/autofs/root.c.orig	2010-09-13 20:18:15.000000000 +0200
+++ linux-2.6.36-rc4/fs/autofs/root.c	2010-09-13 21:02:11.000000000 +0200
@@ -27,7 +27,9 @@ static int autofs_root_unlink(struct ino
 static int autofs_root_rmdir(struct inode *,struct dentry *);
 static int autofs_root_mkdir(struct inode *,struct dentry *,int);
 static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
+#ifdef CONFIG_COMPAT
 static long autofs_root_compat_ioctl(struct file *,unsigned int,unsigned long);
+#endif

 const struct file_operations autofs_root_operations = {
 	.llseek		= generic_file_llseek,
