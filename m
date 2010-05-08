Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab0EHUG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 16:06:26 -0400
Received: from amanaus.varma-el.com ([194.186.189.102]:44874 "EHLO
	amanaus.varma-el.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0EHUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 16:06:25 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 May 2010 16:06:24 EDT
Message-ID: <4BE5C203.6060509@varma-el.com>
Date: Sat, 08 May 2010 23:56:51 +0400
From: Andrey Volkov <avolkov@varma-el.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>, David Gibson <dwg@au1.ibm.com>,
       linuxppc-dev list <Linuxppc-dev@ozlabs.org>
Subject: Fix [e]glibc build process
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix [e]glibc build process destruction (more precisely _assembler_
is die when try to compile getcontext.S since stdint.h coldn't be assembled)
intruduced by patch:

commit: 162d92dfb79a0b5fc03380b8819fa5f870ebf1e
Date: Mon, 8 Feb 2010 11:51:05 +0000 (11:51 +0000)
from: Dave Kleikamp

Signed-off-by: Andrey Volkov <avolkov@varma-el.com>

---

 arch/powerpc/include/asm/ptrace.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index 9e2d84c..025912b 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -27,8 +27,10 @@
 #ifdef __KERNEL__
 #include <linux/types.h>
 #else
+#ifndef __ASSEMBLY__
 #include <stdint.h>
 #endif
+#endif

 #ifndef __ASSEMBLY__

