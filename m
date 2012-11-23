Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2KWQ3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:29:12 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:60609 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2KWQ3L convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 23 Nov 2012 11:29:11 -0500
Message-Id: <50AFB29F02000078000AAE8E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 23 Nov 2012 16:30:07 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mjg@redhat.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: [PATCH] x86/EFI: properly init-annotate BGRT code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These items are only ever referenced from initialization code.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/platform/efi/efi-bgrt.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- 3.7-rc6/arch/x86/platform/efi/efi-bgrt.c
+++ 3.7-rc6-x86-BGRT-init/arch/x86/platform/efi/efi-bgrt.c
@@ -11,20 +11,21 @@
  * published by the Free Software Foundation.
  */
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
 
 struct acpi_table_bgrt *bgrt_tab;
-void *bgrt_image;
-size_t bgrt_image_size;
+void *__initdata bgrt_image;
+size_t __initdata bgrt_image_size;
 
 struct bmp_header {
 	u16 id;
 	u32 size;
 } __packed;
 
-void efi_bgrt_init(void)
+void __init efi_bgrt_init(void)
 {
 	acpi_status status;
 	void __iomem *image;



