Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2JMC34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:29:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18663 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2JMC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:54 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Vga9xQEG0NMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=J3idaZ4RpfwA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=drOt6m5kAAAA:8 a=JhPXCRxtS0kydgbXLZYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022952.704673488@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 02/25] arm: Use Kbuild infrastructure to handle asm-generic headers
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0002-arm-Use-Kbuild-infrastructure-to-handle-asm-generic-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use Kbuild infrastructure to handle the asm-generic headers
and remove the wrapper headers that call them.

This only affects headers that do nothing but include the generic
equivalent. It does not touch any header that does a little more.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/include/asm/Kbuild     |    2 ++
 arch/arm/include/asm/kvm_para.h |    1 -
 arch/avr32/include/asm/ipcbuf.h |    1 -
 3 files changed, 2 insertions(+), 2 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_para.h
 delete mode 100644 arch/avr32/include/asm/ipcbuf.h

diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 8a7196c..ad80160 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -13,6 +13,7 @@ generic-y += ioctl.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
+generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += msgbuf.h
@@ -35,3 +36,4 @@ generic-y += termios.h
 generic-y += timex.h
 generic-y += types.h
 generic-y += unaligned.h
+generic-y += ipcbuf.h
diff --git a/arch/arm/include/asm/kvm_para.h b/arch/arm/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/arm/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/avr32/include/asm/ipcbuf.h b/arch/avr32/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/avr32/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
-- 
1.7.10.4


