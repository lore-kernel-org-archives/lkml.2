Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1BZRyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 12:54:43 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53468 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1BZRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 12:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uXlRrcFpuGPHSKU0ZUHQTaAAupc7I9/2lbuBMcsBEMxni29LudT7Aee5qPlZPayB4B
         T04Oh/l6ed8STmxVMyz3t/dH1sxRsKZblR5hL3htxh+18U+zZahVGEhDOkxbEf+tbRGm
         QOcmrr/vIGXh5dXV1NCDZrMYfQrNEOokKGAQ8=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86, boot: Use common ELF header defines
Date: Sat, 26 Feb 2011 12:54:02 -0500
Message-Id: <1298742844-8256-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
References: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/elf.h> defines elfhdr and elf_phdr appropriately for 32-bit
and 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/boot/compressed/misc.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3a19d04..2d57c97 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -275,13 +275,8 @@ static void error(char *x)
 
 static void parse_elf(void *output)
 {
-#ifdef CONFIG_X86_64
-	Elf64_Ehdr ehdr;
-	Elf64_Phdr *phdrs, *phdr;
-#else
-	Elf32_Ehdr ehdr;
-	Elf32_Phdr *phdrs, *phdr;
-#endif
+	struct elfhdr ehdr;
+	struct elf_phdr *phdrs, *phdr;
 	void *dest;
 	int i;
 
-- 
1.7.4

