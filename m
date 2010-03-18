Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0CRSVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:21:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54220 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0CRSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kjmD8Bqq01KY+YtlIWfjjU9SvhMJRi+Qm3d/EGve3MSiGBtobAPVuY5EptsXTRvMmJ
         zHwQVSY6accsN6CCQJIZKpXz5vChI4CdCILfKu0yBHnsFvoeMqEEpCi0TfwQmTnQPtl6
         BMQ0KhRHh6VpjwhIun94UowjtISGfjyzztL88=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86-32: Don't set ignore_fpu_irq in simd exception
Date: Thu, 18 Mar 2010 14:20:53 -0400
Message-Id: <1268936453-3727-6-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268936453-3727-1-git-send-email-brgerst@gmail.com>
References: <1268936453-3727-1-git-send-email-brgerst@gmail.com>
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
index 6384066..91da091 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -697,10 +697,6 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
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

