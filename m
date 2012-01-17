Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2AQMfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:35:06 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50603 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243Ab2AQMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:35:03 -0500
From: =?UTF-8?q?Bj=C3=B8rn=20Forsman?= <bjorn.forsman@gmail.com>
To: hskinnemoen@gmail.com, egtvedt@samfundet.no, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Forsman?= <bjorn.forsman@gmail.com>
Subject: [PATCH] AVR32: unbreak build by enabling CONFIG_GENERIC_ATOMIC64
Date: Tue, 17 Jan 2012 13:34:17 +0100
Message-Id: <1326803657-18557-1-git-send-email-bjorn.forsman@gmail.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error on AVR32:

  kernel/trace/trace_clock.c:117: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘trace_counter’
  kernel/trace/trace_clock.c: In function ‘trace_clock_counter’:
  kernel/trace/trace_clock.c:126: error: implicit declaration of function ‘atomic64_add_return’
  kernel/trace/trace_clock.c:126: error: ‘trace_counter’ undeclared (first use in this function)
  kernel/trace/trace_clock.c:126: error: (Each undeclared identifier is reported only once
  kernel/trace/trace_clock.c:126: error: for each function it appears in.)
  make[2]: *** [kernel/trace/trace_clock.o] Error 1

Signed-off-by: Bjørn Forsman <bjorn.forsman@gmail.com>
---
I'm not on the list so please keep me in the To/Cc field.

 arch/avr32/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 197e96f..bb521c1 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -10,6 +10,7 @@ config AVR32
 	select GENERIC_IRQ_PROBE
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
+	select GENERIC_ATOMIC64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
-- 
1.7.5.4

