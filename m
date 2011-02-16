Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1BPOew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:34:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43356 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1BPOeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xx3/G38sV7R2DtvJNgAY/XVMCOfID4akV9KZiGHx9t9D6MGjsVoIueIPboA2XOMn57
         nLjBTeg3BDWM8gMUSdKo2o9RftEPhagnbtbv78yHwBiuMBLWIa+a5zbJ8BmMLZn9UFzw
         z89MlmyNkaZ4s3n1T9JJdH46Hi1zT0BfZJqgI=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH] Include asm/time.h in cevt-r4k.h
Date: Wed, 16 Feb 2011 20:26:07 +0530
Message-Id: <1297868167-26738-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Following error occurs when compiling files which includes asm/cevt-r4k.h

arch/mips/include/asm/cevt-r4k.h:21:56: error: 'enum clock_event_mode' declared inside parameter list
arch/mips/include/asm/cevt-r4k.h:21:56: error: its scope is only this definition or declaration, which is probably not what you want

This left unnoticed since we will not see this error if we include time.h before cevt-r4k.h .

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/include/asm/cevt-r4k.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/cevt-r4k.h b/arch/mips/include/asm/cevt-r4k.h
index fa4328f..ae06b7f 100644
--- a/arch/mips/include/asm/cevt-r4k.h
+++ b/arch/mips/include/asm/cevt-r4k.h
@@ -14,6 +14,8 @@
 #ifndef __ASM_CEVT_R4K_H
 #define __ASM_CEVT_R4K_H
 
+#include <asm/time.h>
+
 DECLARE_PER_CPU(struct clock_event_device, mips_clockevent_device);
 
 void mips_event_handler(struct clock_event_device *dev);
-- 
1.7.0.4

