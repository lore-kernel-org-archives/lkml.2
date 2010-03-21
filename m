Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0CUNBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:01:31 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:33347 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0CUNBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Htfx/SVs7oGsZYR/KlcTmcI8X5XNofad/O1lKyZjBvsoDdq580XAk6XafjGV/8QSHn
         YXDimkrIIfpVlquvVCszBL9lbmtGr74QcFsmyrse6ue+ig65dcXMwCcyP3cKxNRgGfO1
         MriJGKpiOFrAZqA/GjCqpmNZmtESxvaZyg4iU=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86-32: Don't set ignore_fpu_irq in simd exception
Date: Sun, 21 Mar 2010 09:00:46 -0400
Message-Id: <1269176446-2489-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1269176446-2489-1-git-send-email-brgerst@gmail.com>
References: <1269176446-2489-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any processor that supports simd will have an internal fpu, and the
irq13 handler will not be enabled.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/traps.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d53a443..3e271ed 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -672,10 +672,6 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-#ifdef CONFIG_X86_32
-	ignore_fpu_irq = 1;
-#endif
-
 	math_error(regs, error_code, 19);
 }
 
-- 
1.6.6.1

