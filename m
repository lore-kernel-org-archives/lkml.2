Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2DSDKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:10:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:37997 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab2DSDKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:10:09 -0400
Date: Thu, 19 Apr 2012 13:10:07 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Security subsystem fixes for 3.4
In-Reply-To: <alpine.LRH.2.02.1204181349550.24162@tundra.namei.org>
Message-ID: <alpine.LRH.2.02.1204191309180.415@tundra.namei.org>
References: <alpine.LRH.2.02.1204181349550.24162@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fcaps patch introduced a build error for some users, sorry.

Please pull the fix below.



The following changes since commit b6a89584c36f307f2c2bbb136ea50985ca4bc7b4:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jmorris/linux-security

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Jonghwan Choi (1):
      security: fix compile error in commoncap.c

 security/commoncap.c |    1 +
 1 file changed, 1 insertion(+)

commit 51b79bee627d526199b2f6a6bef8ee0c0739b6d1
Author: Jonghwan Choi <jhbird.choi@samsung.com>
Date:   Wed Apr 18 17:23:04 2012 -0400

    security: fix compile error in commoncap.c
    
    Add missing "personality.h"
    security/commoncap.c: In function 'cap_bprm_set_creds':
    security/commoncap.c:510: error: 'PER_CLEAR_ON_SETID' undeclared (first use in this function)
    security/commoncap.c:510: error: (Each undeclared identifier is reported only once
    security/commoncap.c:510: error: for each function it appears in.)
    
    Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
    Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/commoncap.c b/security/commoncap.c
index 0ecf4ba..71a166a 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -29,6 +29,7 @@
 #include <linux/securebits.h>
 #include <linux/user_namespace.h>
 #include <linux/binfmts.h>
+#include <linux/personality.h>
 
 /*
  * If a non-root user executes a setuid-root binary in
