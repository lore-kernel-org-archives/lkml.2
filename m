Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0LLXsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36756 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab0LLXsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:21 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: mroberto@cpti.cetuc.puc-rio.br, rmk+kernel@arm.linux.org.uk,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [194/223] ARM: 6456/1: Fix for building DEBUG with sa11xx_base.c as a module.
Message-Id: <20101212234820.56C51B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

commit b9f515e3e3861abbaa093359f7c6f31283695228 upstream.

This patch fixes a compilation issue when compiling PCMCIA SA1100
support as a module with PCMCIA_DEBUG enabled. The symbol
soc_pcmcia_debug was not beeing exported.
ARM: pcmcia: Fix for building DEBUG with sa11xx_base.c as a module.

This patch fixes a compilation issue when compiling PCMCIA SA1100
support as a module with PCMCIA_DEBUG enabled. The symbol
soc_pcmcia_debug was not beeing exported.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pcmcia/soc_common.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/pcmcia/soc_common.c
===================================================================
--- linux.orig/drivers/pcmcia/soc_common.c
+++ linux/drivers/pcmcia/soc_common.c
@@ -65,6 +65,7 @@ void soc_pcmcia_debug(struct soc_pcmcia_
 		va_end(args);
 	}
 }
+EXPORT_SYMBOL(soc_pcmcia_debug);
 
 #endif
 
