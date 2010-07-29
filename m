Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab0G2XF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:05:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:49524 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab0G2XFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:05:25 -0400
Date: Fri, 30 Jul 2010 09:05:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #7 0/13] AppArmor security module
In-Reply-To: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
Message-ID: <alpine.LRH.2.00.1007300903440.7719@tundra.namei.org>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010, John Johansen wrote:

> This is the seveth general posting of the newest version of the
> AppArmor security module it has been rewritten to use the security_path
> hooks instead of the previous vfs approach.  The current implementation
> is aimed at being as semantically close to previous versions of AppArmor
> as possible while using the existing LSM infrastructure.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Please carry out any further development against the above tree.

Note that I added the patch below to update AA against the latest 
version of path_truncate:


commit 08c702abe63c2da88f811d5c9f98eb01eb8edc77
Author: James Morris <jmorris@namei.org>
Date:   Fri Jul 30 09:02:04 2010 +1000

    AppArmor: update path_truncate method to latest version
    
    Remove extraneous path_truncate arguments from the AppArmor hook,
    as they've been removed from the LSM API.
    
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 7daf0d5..8db33a8 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -278,8 +278,7 @@ static int apparmor_path_mknod(struct path *dir, struct dentry *dentry,
 	return common_perm_create(OP_MKNOD, dir, dentry, AA_MAY_CREATE, mode);
 }
 
-static int apparmor_path_truncate(struct path *path, loff_t length,
-				  unsigned int time_attrs)
+static int apparmor_path_truncate(struct path *path)
 {
 	struct path_cond cond = { path->dentry->d_inode->i_uid,
 				  path->dentry->d_inode->i_mode


-- 
James Morris
<jmorris@namei.org>
