Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0KIR3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:29:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41202 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0KIR3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:29:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:organization:cc:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=FfCcz1nCsJqxV9uIcxTMoGifpEs4+7idDZgJt/hIraqlkLxuUeaVqig3a7uKTemdG2
         0Eeh/xYlUt+2GtAyRB0qVEG+WeBXUF/pgUOQ/Q2u4nSMw44AHb++/Zj1aPnCMINgoazb
         5tJ4n/Ny4/Z9+fEfWJIdvrtFKCvL1Uxd6vx2k=
From: Florian Fainelli <florian@openwrt.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH] sound/mixart: avoid redefining {readl,write}_{le,be} accessors
Date: Tue, 9 Nov 2010 18:29:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-server; KDE/4.5.1; x86_64; ; )
Organization: OpenWrt
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091829.08664.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>

If the platform already provides a definition for these accessors
do not redefine them. The warning was caught on MIPS.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/sound/pci/mixart/mixart_hwdep.h b/sound/pci/mixart/mixart_hwdep.h
index a46f508..812e288 100644
--- a/sound/pci/mixart/mixart_hwdep.h
+++ b/sound/pci/mixart/mixart_hwdep.h
@@ -25,11 +25,21 @@
 
 #include <sound/hwdep.h>
 
+#ifndef readl_be
 #define readl_be(x) be32_to_cpu(__raw_readl(x))
+#endif
+
+#ifndef writel_be
 #define writel_be(data,addr) __raw_writel(cpu_to_be32(data),addr)
+#endif
 
+#ifndef readl_le
 #define readl_le(x) le32_to_cpu(__raw_readl(x))
+#endif
+
+#ifndef writel_le
 #define writel_le(data,addr) __raw_writel(cpu_to_le32(data),addr)
+#endif
 
 #define MIXART_MEM(mgr,x)	((mgr)->mem[0].virt + (x))
 #define MIXART_REG(mgr,x)	((mgr)->mem[1].virt + (x))
-- 
1.7.1

