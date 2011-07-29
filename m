Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1G2E4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 00:56:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54221 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1G2E4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 00:56:47 -0400
Date: Fri, 29 Jul 2011 14:56:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729145644.ce9b20c535822ede35cd0a0c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/cell/spu_syscalls.c: In function 'spufs_calls_get':
arch/powerpc/platforms/cell/spu_syscalls.c:42:2: error: implicit declaration of function 'try_module_get'
arch/powerpc/platforms/cell/spu_syscalls.c: In function 'spufs_calls_put':
arch/powerpc/platforms/cell/spu_syscalls.c:54:2: error: implicit declaration of function 'module_put'

Caused by commit f7f927183dba ("powerpc: various straight conversions
from module.h --> export.h").  This file should not be modified.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 14:53:16 +1000
Subject: [PATCH] Partial revert of f7f927183dba

"powerpc: various straight conversions from module.h --> export.h"

This file needs module.h.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/platforms/cell/spu_syscalls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
index 60fc5ec..75530d9 100644
--- a/arch/powerpc/platforms/cell/spu_syscalls.c
+++ b/arch/powerpc/platforms/cell/spu_syscalls.c
@@ -22,7 +22,7 @@
  */
 #include <linux/file.h>
 #include <linux/fs.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/rcupdate.h>
 
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
