Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0FIIEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:04:23 -0400
Received: from daytona.panasas.com ([67.152.220.89]:18099 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755859Ab0FIIET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:04:19 -0400
Message-ID: <4C0F4B00.4090307@panasas.com>
Date: Wed, 09 Jun 2010 11:04:16 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] um, hweight: Fix UML boot crash
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2010 08:04:19.0061 (UTC) FILETIME=[5CA91250:01CB07AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

Obviously UML cannot stomach callee reg-saving trickery
introduced with d61931d89be506372d01a90d1755f6d0a9fafe2d
(x86: Add optimized popcnt variants) and oopses during boot:
http://marc.info/?l=linux-kernel&m=127522065202435&w=2

Redirect arch_hweight.h include from the x86 portion to the generic
arch_hweight.h which is a fallback to the software hweight routines.

LKML-Reference: <201005271944.09541.toralf.foerster@gmx.de>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/um/include/asm/arch_hweight.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
 create mode 100644 arch/um/include/asm/arch_hweight.h

diff --git a/arch/um/include/asm/arch_hweight.h b/arch/um/include/asm/arch_hweight.h
new file mode 100644
index 0000000..c656cf4
--- /dev/null
+++ b/arch/um/include/asm/arch_hweight.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_UM_HWEIGHT_H
+#define _ASM_UM_HWEIGHT_H
+
+#include <asm-generic/bitops/arch_hweight.h>
+
+#endif
-- 1.7.1 
