Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab0FPLfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:35:51 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43808 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671Ab0FPLfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:35:50 -0400
Date: Wed, 16 Jun 2010 13:35:48 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 5/9] Removing dead CONFIG_BLK_DEV_IDE
Message-ID: <20100616113548.GA10065@faui48a.informatik.uni-erlangen.de>
References: <cover.1275925108.git.siccegge@cs.fau.de> <73e9e4bd7615488c9567f02f8962825386956365.1275925108.git.siccegge@cs.fau.de> <AANLkTillx50SaxZU2cT9YSlS4uRF_ED5-wlG-JwfXfFT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTillx50SaxZU2cT9YSlS4uRF_ED5-wlG-JwfXfFT@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 12:23:06PM -0600, Shane McDonald wrote:
>   I wonder if, instead of deleting the code, the constant should be
> changed from CONFIG_BLK_DEV_IDE to CONFIG_IDE.  The original
> patch that removed CONFIG_BLK_DEV_IDE seemed to make this change:
> http://kerneltrap.org/mailarchive/linux-kernel/2008/8/13/2929444
> 
> Shane

You're probably right, updated patch below

-------
From: Christoph Egger <siccegge@cs.fau.de>
Date: Mon, 7 Jun 2010 17:29:48 +0200
Subject: [PATCH 5/9] Removing dead CONFIG_BLK_DEV_IDE

CONFIG_BLK_DEV_IDE doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
diff --git a/arch/mips/mti-malta/malta-setup.c
b/arch/mips/mti-malta/malta-setup.c
index b7f37d4..f6a5ea8 100644
--- a/arch/mips/mti-malta/malta-setup.c
+++ b/arch/mips/mti-malta/malta-setup.c
@@ -105,7 +105,7 @@ static void __init fd_activate(void)
 }
 #endif
 
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_IDE
 static void __init pci_clock_check(void)
 {
        unsigned int __iomem *jmpr_p =
@@ -207,7 +207,7 @@ void __init plat_mem_setup(void)
        if (mips_revision_sconid == MIPS_REVISION_SCON_BONITO)
                bonito_quirks_setup();
 
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_IDE
        pci_clock_check();
 #endif
 
