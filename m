Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1KGXbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:31:32 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:42542
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751150Ab1KGXbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:31:31 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc: Remove buggy 9-year-old test for binutils < 2.12.1
Date: Mon,  7 Nov 2011 18:30:43 -0500
Message-Id: <1320708643-32631-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent binutils refuses to assemble AltiVec opcodes when in e500/SPE
mode, as some of those opcodes alias the "SPE" instructions.  This
triggers an ancient binutils version check even when building a kernel
with CONFIG_ALTIVEC disabled.

In theory, the check could be conditionalized on CONFIG_ALTIVEC, but in
practice it has long outlived its utility.  It is virtually impossible
to find binutils older than 2.12.1 (released 2002) in the wild anymore.
Even ancient RedHat Enterprise Linux 4 has binutils-2.14.

To fix the kernel build when done natively on e500 systems with this new
binutils, the test is simply removed.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/Makefile |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 57af16e..70ba0c0 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -255,12 +255,6 @@ checkbin:
 		echo 'disable kernel modules' ; \
 		false ; \
 	fi
-	@if ! /bin/echo dssall | $(AS) -many -o $(TOUT) >/dev/null 2>&1 ; then \
-		echo -n '*** ${VERSION}.${PATCHLEVEL} kernels no longer build ' ; \
-		echo 'correctly with old versions of binutils.' ; \
-		echo '*** Please upgrade your binutils to 2.12.1 or newer' ; \
-		false ; \
-	fi
 
 CLEAN_FILES += $(TOUT)
 
-- 
1.7.2.5

