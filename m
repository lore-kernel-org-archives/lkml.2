Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab1EMBFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 21:05:39 -0400
Received: from tundra.namei.org ([65.99.196.166]:54108 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759054Ab1EMBFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 21:05:37 -0400
Date: Fri, 13 May 2011 11:05:31 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Fix SELinux logging regression
Message-ID: <alpine.LRH.2.00.1105131102230.3709@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes some debug logging code which should not have been committed, 
which swamps the system logs in some circumstances.

Please pull.

The following changes since commit 411f05f123cbd7f8aa1edcae86970755a6e2a9d9:
  Ingo Molnar (1):
        vsprintf: Turn kptr_restrict off by default

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Eric Paris (1):
      SELinux: delete debugging printks from filename_trans rule processing

James Morris (1):
      Merge branch 'for-linus' of git://git.infradead.org/users/eparis/selinux into for-linus

 security/selinux/ss/policydb.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

---

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index e6e7ce0..7102457 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1819,8 +1819,6 @@ static int filename_trans_read(struct policydb *p, void *fp)
 		goto out;
 	nel = le32_to_cpu(buf[0]);
 
-	printk(KERN_ERR "%s: nel=%d\n", __func__, nel);
-
 	last = p->filename_trans;
 	while (last && last->next)
 		last = last->next;
@@ -1857,8 +1855,6 @@ static int filename_trans_read(struct policydb *p, void *fp)
 			goto out;
 		name[len] = 0;
 
-		printk(KERN_ERR "%s: ft=%p ft->name=%p ft->name=%s\n", __func__, ft, ft->name, ft->name);
-
 		rc = next_entry(buf, fp, sizeof(u32) * 4);
 		if (rc)
 			goto out;

