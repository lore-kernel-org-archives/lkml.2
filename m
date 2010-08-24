Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0HXPUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:20:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47499 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0HXPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=kMqPhV8DC8MJBxPixk8l4d4AyZCHmACcuEeJ4XGyvc7G3vWmZ7FwbZDKSi0j427RwT
         cc2bZcbLP2neg3IOR4FoWz4RVTmQ35xy0W/SfjxYJTDM8u0WaHmjGez97EVDId+eLejP
         PjrMTUMOXaEd+PnVYkXAuWwD2EfNfqPjFFFw4=
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>
Subject: [PATCH] x86, vmware: fix compilation failure due lack of preset_lpj variable
Date: Tue, 24 Aug 2010 12:19:48 -0300
Message-Id: <1282663188-31090-1-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.7.1.569.g6f426
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At commit 9f242dc10e0c3c1eb32d8c83c18650a35fd7f80d the preset_lpj
variable started to be used but vmware.c lacked the include for
"jiffies.h" that defines it causing a build failure.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
 arch/x86/kernel/cpu/vmware.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 227b044..ce9c6c2 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -23,6 +23,7 @@
 
 #include <linux/dmi.h>
 #include <linux/module.h>
+#include <linux/jiffies.h>
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>
-- 
1.7.1.569.g6f426

