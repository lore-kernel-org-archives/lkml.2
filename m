Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1GEHk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 03:40:58 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53957 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab1GEHk5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 5 Jul 2011 03:40:57 -0400
Message-Id: <4E12DC26020000780004C1C1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 05 Jul 2011 08:40:54 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/EFI: properly pre-initialize table pointers
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consumers of the table pointers in struct efi check for
EFI_INVALID_TABLE_ADDR to determine validity, hence these pointers
should all be pre-initialized to this value (rather than zero).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/platform/efi/efi.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- 3.0-rc6/arch/x86/platform/efi/efi.c
+++ 3.0-rc6-x86-EFI/arch/x86/platform/efi/efi.c
@@ -51,7 +51,17 @@
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
 
-struct efi efi;
+struct efi __read_mostly efi = {
+	.mps        = EFI_INVALID_TABLE_ADDR,
+	.acpi       = EFI_INVALID_TABLE_ADDR,
+	.acpi20     = EFI_INVALID_TABLE_ADDR,
+	.smbios     = EFI_INVALID_TABLE_ADDR,
+	.sal_systab = EFI_INVALID_TABLE_ADDR,
+	.boot_info  = EFI_INVALID_TABLE_ADDR,
+	.hcdp       = EFI_INVALID_TABLE_ADDR,
+	.uga        = EFI_INVALID_TABLE_ADDR,
+	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+};
 EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;



