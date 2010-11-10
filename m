Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0KJShI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:37:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56674 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab0KJShG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:37:06 -0500
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/4] x86: rename verify_cpu_64.S to verify_cpu.S
Date: Wed, 10 Nov 2010 10:35:51 -0800
Message-Id: <1289414154-7829-2-git-send-email-kees.cook@canonical.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289414154-7829-1-git-send-email-kees.cook@canonical.com>
References: <1289414154-7829-1-git-send-email-kees.cook@canonical.com>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code is 32bit already, and can be used in 32bit routines.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 arch/x86/boot/compressed/head_64.S                |    2 +-
 arch/x86/kernel/trampoline_64.S                   |    2 +-
 arch/x86/kernel/{verify_cpu_64.S => verify_cpu.S} |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/x86/kernel/{verify_cpu_64.S => verify_cpu.S} (100%)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 52f85a1..35af09d 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -182,7 +182,7 @@ no_longmode:
 	hlt
 	jmp     1b
 
-#include "../../kernel/verify_cpu_64.S"
+#include "../../kernel/verify_cpu.S"
 
 	/*
 	 * Be careful here startup_64 needs to be at a predictable
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 3af2dff..075d130 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -127,7 +127,7 @@ startup_64:
 no_longmode:
 	hlt
 	jmp no_longmode
-#include "verify_cpu_64.S"
+#include "verify_cpu.S"
 
 	# Careful these need to be in the same 64K segment as the above;
 tidt:
diff --git a/arch/x86/kernel/verify_cpu_64.S b/arch/x86/kernel/verify_cpu.S
similarity index 100%
rename from arch/x86/kernel/verify_cpu_64.S
rename to arch/x86/kernel/verify_cpu.S
-- 
1.7.2.3

