Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0CQMbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:31:06 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:25818 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754722Ab0CQMbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:31:00 -0400
Date: Wed, 17 Mar 2010 13:30:56 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: x86@kernel.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, alan@linux.intel.com,
       akpm@linux-foundation.org, hpa@zytor.com
Subject: [PATCH 2/2]: x86 real mode: Set delay port according to kernel
 config
Message-ID: <20100317133056.289d8dc7@marrow.netinsight.se>
In-Reply-To: <20100317132849.7d49939b@marrow.netinsight.se>
References: <20100317132849.7d49939b@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port 0x80 is not safe to use on all x86 boards (see
arch/x86/kernel/io_delay.c), so optionally use 0xed from the kernel
config instead.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 arch/x86/boot/boot.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 98239d2..79880b1 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -73,7 +73,12 @@ static inline u32 inl(u32 port)
 
 static inline void io_delay(void)
 {
+#ifdef CONFIG_IO_DELAY_0XED
+	const u16 DELAY_PORT = 0xed;
+#else
 	const u16 DELAY_PORT = 0x80;
+#endif
+
 	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
 }
 
-- 
1.6.0.4

