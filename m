Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0JARsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:48:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46885 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab0JARsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:48:06 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/2] overlayfs: export security_inode_permission to allow overlayfs to be modular
Date: Fri,  1 Oct 2010 18:48:01 +0100
Message-Id: <1285955282-10240-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285955282-10240-1-git-send-email-apw@canonical.com>
References: <1285955282-10240-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling overlayfs as a module we end up with an unknown symbol
'security_inode_permission'.  Export it.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 security/security.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/security.c b/security/security.c
index ca39940..b8329cc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -556,6 +556,7 @@ int security_inode_permission(struct inode *inode, int mask)
 		return 0;
 	return security_ops->inode_permission(inode, mask);
 }
+EXPORT_SYMBOL_GPL(security_inode_permission);
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {
-- 
1.7.0.4

