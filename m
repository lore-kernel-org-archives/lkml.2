Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab2ASLh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:37:27 -0500
Received: from www62.your-server.de ([213.133.104.62]:46833 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab2ASLhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:37:24 -0500
Message-ID: <4F180069.6090805@iogearbox.net>
Date: Thu, 19 Jan 2012 12:37:13 +0100
From: Daniel Borkmann <danborkmann@iogearbox.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org
CC: Ariane Keller <ariane.keller@tik.ee.ethz.ch>
Subject: [PATCH] microblaze: generic atomic64 support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: danborkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tiny patch adds generic atomic64 support for the Microblaze
architecture.

The patch is against the latest linux-2.6-microblaze tree. It also
fixes the kernel build for microblaze:

CC kernel/trace/trace_clock.o 
kernel/trace/trace_clock.c:117: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before 'trace_counter' 
kernel/trace/trace_clock.c: In function 'trace_clock_counter': 
kernel/trace/trace_clock.c:126: error: implicit declaration of 
function 'atomic64_add_return' 
kernel/trace/trace_clock.c:126: error: 'trace_counter' undeclared 
(first use in this function) 
kernel/trace/trace_clock.c:126: error: (Each undeclared identifier is 
reported only once 
kernel/trace/trace_clock.c:126: error: for each function it appears in.) 
make[2]: *** [kernel/trace/trace_clock.o] Error 1 
make[1]: *** [kernel/trace] Error 2 
make: *** [kernel] Error 2 

(the patch got corrupted beforehand, to that's why the resend)


Signed-off-by: Ariane Keller <ariane.keller@tik.ee.ethz.ch>
Signed-off-by: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
---
 arch/microblaze/Kconfig              |    1 +
 arch/microblaze/include/asm/atomic.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 74f23a4..c8d6efb 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -19,6 +19,7 @@ config MICROBLAZE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
 	select GENERIC_CPU_DEVICES
+	select GENERIC_ATOMIC64
 
 config SWAP
 	def_bool n
diff --git a/arch/microblaze/include/asm/atomic.h b/arch/microblaze/include/asm/atomic.h
index 6d2e1d4..615f539 100644
--- a/arch/microblaze/include/asm/atomic.h
+++ b/arch/microblaze/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define _ASM_MICROBLAZE_ATOMIC_H
 
 #include <asm-generic/atomic.h>
+#include <asm-generic/atomic64.h>
 
 /*
  * Atomically test *v and decrement if it is greater than 0.
