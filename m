Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0KIWRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:17:52 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49232 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0KIWRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:17:51 -0500
Date: Tue, 9 Nov 2010 14:17:49 -0800
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: rename verify_cpu_64.S to verify_cpu.S
Message-ID: <20101109221749.GY5876@outflux.net>
References: <20101109221704.GX5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109221704.GX5876@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code is 32bit already, and can be used in 32bit routines.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
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


-- 
Kees Cook
Ubuntu Security Team
