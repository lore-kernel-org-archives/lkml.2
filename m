Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0JTFK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:10:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55461 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab0JTFK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:10:28 -0400
Date: Wed, 20 Oct 2010 16:10:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: linux-next: build failure after merge of the final tree
 (security-testing tree related)
Message-Id: <20101020161024.af794b4a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

security/selinux/ss/services.c: In function 'security_read_policy':
security/selinux/ss/services.c:3172: error: implicit declaration of function 'vmalloc_user'
security/selinux/ss/services.c:3172: warning: assignment makes pointer from integer without a cast

Caused by commit ed167abda544bb7f8cf09dc3d3608c79e1cfb25f ("SELinux:
allow userspace to read policy back out of the kernel") and
bb17427490e1e295f3c0550c308684bd952a585d ("selinux: implement mmap
on /selinux/policy").

Please see Rule 1 (in Documentation/SubmitChecklist).

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 20 Oct 2010 16:08:00 +1100
Subject: [PATCH] selinux: include vmalloc.h for vmalloc_user

---
 security/selinux/ss/services.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 3a1739b..223c1ff 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -51,6 +51,7 @@
 #include <linux/mutex.h>
 #include <linux/selinux.h>
 #include <linux/flex_array.h>
+#include <linux/vmalloc.h>
 #include <net/netlabel.h>
 
 #include "flask.h"
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
