Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161214Ab2JXVLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:11:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:5829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161186Ab2JXVLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:11:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,642,1344236400"; 
   d="scan'208";a="231932310"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Howells <dhowells@redhat.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [PATCH] Makefile: Documentation for external tool should be correct
Date: Wed, 24 Oct 2012 14:11:48 -0700
Message-Id: <1351113108-23277-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

If one includes documentation for an external tool, it should be
correct.  This is not:

1. Overriding the input to rngd should typically be neither
   necessary nor desired.  This is especially so since newer
   versions of rngd support a number of different *types* of sources.
2. The default kernel-exported device is called /dev/hwrng not
   /dev/hwrandom nor /dev/hw_random (both of which were used in the
   past; however, kernel and udev seem to have converged on
   /dev/hwrng.)

Overall it is better if the documentation for rngd is kept with rngd
rather than in a kernel Makefile.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
---
 kernel/Makefile |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 0dfeca4..86e3285 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -174,10 +174,8 @@ signing_key.priv signing_key.x509: x509.genkey
 	@echo "###"
 	@echo "### If this takes a long time, you might wish to run rngd in the"
 	@echo "### background to keep the supply of entropy topped up.  It"
-	@echo "### needs to be run as root, and should use a hardware random"
-	@echo "### number generator if one is available, eg:"
-	@echo "###"
-	@echo "###     rngd -r /dev/hwrandom"
+	@echo "### needs to be run as root, and uses a hardware random"
+	@echo "### number generator if one is available."
 	@echo "###"
 	openssl req -new -nodes -utf8 $(sign_key_with_hash) -days 36500 -batch \
 		-x509 -config x509.genkey \
-- 
1.7.6.5

