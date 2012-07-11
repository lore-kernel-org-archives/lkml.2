Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab2GKQMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:12:01 -0400
Received: from tundra.namei.org ([65.99.196.166]:58787 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738Ab2GKQL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:11:58 -0400
Date: Thu, 12 Jul 2012 02:11:53 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] selinux: fix regression
Message-ID: <alpine.LRH.2.02.1207120211140.24051@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.

The following changes since commit 055c9fa8874fa7261eec7a268366565db84af474:
  Linus Torvalds (1):
        Merge tag 'fixes-for-v3.5' of git://git.kernel.org/.../linusw/linux-gpio

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Andrew Morton (1):
      selinux: fix regression in selinux_inode_setattr()

 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 17c284ce9688ece1fff024ef4a66f8f115017c06
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Jul 10 23:24:24 2012 -0700

    selinux: fix regression in selinux_inode_setattr()
    
    akpm: This patch is needed to fix a box-killing post-3.4 X11 regression on
    my test machine.
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 372ec65..4c62155 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2717,7 +2717,7 @@ static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 			ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_TIMES_SET))
 		return dentry_has_perm(cred, dentry, FILE__SETATTR);
 
-	if (ia_valid & ATTR_SIZE)
+	if ((ia_valid & ATTR_SIZE) && selinux_policycap_openperm)
 		av |= FILE__OPEN;
 
 	return dentry_has_perm(cred, dentry, av);
