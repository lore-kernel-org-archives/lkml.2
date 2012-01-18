Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2ARNr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:47:56 -0500
Received: from www62.your-server.de ([213.133.104.62]:35900 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab2ARNrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:47:55 -0500
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jan 2012 08:47:55 EST
Message-ID: <20120118142526.18693wpo1gg21vly@mail.your-server.de>
Date: Wed, 18 Jan 2012 14:25:26 +0100
From: danborkmann@iogearbox.net
To: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au,
        Ariane Keller <ariane.keller@tik.ee.ethz.ch>
Subject: [PATCH] microblaze: generic atomic64 support
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.6)
X-Authenticated-Sender: danborkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tiny patch adds generic atomic64 support for the Microblaze  
architecture. The patch
is against the latest linux-2.6-microblaze tree. It also fixes the  
kernel build for microblaze:

   CC      kernel/trace/trace_clock.o
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


Signed-off-by: Ariane Keller <ariane.keller@tik.ee.ethz.ch>
Signed-off-by: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>

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
diff --git a/arch/microblaze/include/asm/atomic.h  
b/arch/microblaze/include/asm/atomic.h
index 6d2e1d4..615f539 100644
--- a/arch/microblaze/include/asm/atomic.h
+++ b/arch/microblaze/include/asm/atomic.h
@@ -2,6 +2,7 @@
  #define _ASM_MICROBLAZE_ATOMIC_H

  #include <asm-generic/atomic.h>
+#include <asm-generic/atomic64.h>

  /*
   * Atomically test *v and decrement if it is greater than 0.


