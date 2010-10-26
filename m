Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab0JZKvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:51:15 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47240 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759773Ab0JZKvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:51:12 -0400
Message-Id: <20101026105106.202173251@szeredi.hu>
References: <20101026105028.575362331@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 26 Oct 2010 12:50:33 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: apw@canonical.com
Subject: [PATCH 5/8 v4] export security_inode_permission to allow overlayfs to be modular
Content-Disposition: inline; filename=export-security_inode_permission.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

When compiling overlayfs as a module we end up with an unknown symbol
'security_inode_permission'.  Export it.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 security/security.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2010-10-26 11:29:16.000000000 +0200
+++ linux-2.6/security/security.c	2010-10-26 11:29:28.000000000 +0200
@@ -520,6 +520,7 @@ int security_inode_permission(struct ino
 		return 0;
 	return security_ops->inode_permission(inode, mask);
 }
+EXPORT_SYMBOL_GPL(security_inode_permission);
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {

-- 
