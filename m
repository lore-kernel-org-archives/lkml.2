Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2LTTRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:17:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49087 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab2LTTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:09 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] x86, efi: correct precedence of operators in setup_efi_pci
Date: Thu, 20 Dec 2012 14:11:33 -0500
Message-Id: <1356030701-16284-25-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current code, the condition in the if() doesn't make much sense due to
precedence of operators.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/boot/compressed/eboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b1942e2..18e329c 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -302,7 +302,7 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (status != EFI_SUCCESS)
 			continue;
 
-		if (!attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM)
+		if (!(attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM))
 			continue;
 
 		if (!pci->romimage || !pci->romsize)
-- 
1.8.0

