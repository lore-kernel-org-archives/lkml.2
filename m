Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0KVHeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:34:06 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47048 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab0KVHeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:34:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=u8yfAsXuJs8PM7SzhUFDIFPcMACZ51UwqEMgWwj3AgxihcySGPo6VFpYi7hF8FKv9Z
         iQGV72xfprXyUtyGRWfuJ/gvTOlWWlzRlayuaeV6tkF7jnqvJfpukzwmZltc2DXmehQ4
         tkBjVFPpJWgp3tFwGRg8d1kX5UnCu/WSWz6+8=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] generic-ipi: add lock context annotations
Date: Mon, 22 Nov 2010 16:33:52 +0900
Message-Id: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipi_call_[un]lock[_irq] functions grab/release a spin lock
but were missing proper annotations. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/smp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 12ed8b0..5a62f1f 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -511,21 +511,25 @@ int smp_call_function(smp_call_func_t func, void *info, int wait)
 EXPORT_SYMBOL(smp_call_function);
 
 void ipi_call_lock(void)
+	__acquires(call_function.lock)
 {
 	raw_spin_lock(&call_function.lock);
 }
 
 void ipi_call_unlock(void)
+	__releases(call_function.lock)
 {
 	raw_spin_unlock(&call_function.lock);
 }
 
 void ipi_call_lock_irq(void)
+	__acquires(call_function.lock)
 {
 	raw_spin_lock_irq(&call_function.lock);
 }
 
 void ipi_call_unlock_irq(void)
+	__releases(call_function.lock)
 {
 	raw_spin_unlock_irq(&call_function.lock);
 }
-- 
1.7.0.4

