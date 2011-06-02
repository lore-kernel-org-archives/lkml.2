Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1FBT7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:59:46 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43861 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752701Ab1FBT7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:59:45 -0400
Date: Thu, 2 Jun 2011 14:59:43 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x66, UV: Enable 64-bit ACPI MFCG support for SGI UV2
	platform
Message-ID: <20110602195943.GA27079@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable 64-bit ACPI MFCG support for SGI UV2 platform. The check is similar
to the check on UV1. UV2 has a different oem_id string.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/pci/mmconfig-shared.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux.orig/arch/x86/pci/mmconfig-shared.c	2011-05-31 12:13:19.635285219 -0500
+++ linux/arch/x86/pci/mmconfig-shared.c	2011-06-02 14:41:26.645034257 -0500
@@ -519,7 +519,8 @@ static int __init acpi_mcfg_check_entry(
 	if (cfg->address < 0xFFFFFFFF)
 		return 0;
 
-	if (!strcmp(mcfg->header.oem_id, "SGI"))
+	if (!strcmp(mcfg->header.oem_id, "SGI") ||
+	    		!strcmp(mcfg->header.oem_id, "SGI2"))
 		return 0;
 
 	if (mcfg->header.revision >= 1) {
