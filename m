Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab2GBFeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 01:34:16 -0400
Received: from linux-sh.org ([111.68.239.195]:33304 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab2GBFeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 01:34:15 -0400
Date: Mon, 2 Jul 2012 14:34:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: James Morris <james.l.morris@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] security: Fix nommu build.
Message-ID: <20120702053408.GA24230@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The security + nommu configuration presently blows up with an undefined
reference to BDI_CAP_EXEC_MAP:

security/security.c: In function 'mmap_prot':
security/security.c:687:36: error: dereferencing pointer to incomplete type
security/security.c:688:16: error: 'BDI_CAP_EXEC_MAP' undeclared (first use in this function)
security/security.c:688:16: note: each undeclared identifier is reported only once for each function it appears in

include backing-dev.h directly to fix it up.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 security/security.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/security/security.c b/security/security.c
index 3efc9b1..860aeb3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -23,6 +23,7 @@
 #include <linux/mman.h>
 #include <linux/mount.h>
 #include <linux/personality.h>
+#include <linux/backing-dev.h>
 #include <net/flow.h>
 
 #define MAX_LSM_EVM_XATTR	2
