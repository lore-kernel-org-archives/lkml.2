Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1EFQwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:52:01 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50731 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab1EFQwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=rES+JvDrOv8vGyGnA9SA3C/NCuG8rM/TOj/M88w0YLY1ZC1MY/ohPFkymUzumTdJ1A
         AZ0r+aZYQKGlYdxxVwX1dTfmxBc4vnD8eIAyocizZYoRjmzpXACecT3h8mdsTYJOhsIe
         QSHYLydvEwLJ8k5/qcDUjT7ukIsqJh1XsSl+Y=
MIME-Version: 1.0
Date: Fri, 6 May 2011 19:51:59 +0300
Message-ID: <BANLkTin7e1xkXTWMLQ5fyAZStiCGO-Apug@mail.gmail.com>
Subject: [PATCH] arm: kernel: module: Remove the r_offset check which is
 always false
From: Maxin John <maxin.john@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking the unsigned 'r_offset' for less than zero will always be false.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index fee7c36..fc74bd3 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -92,7 +92,7 @@ apply_relocate(Elf32_Shdr *sechdrs, const char
*strtab, unsigned int symindex,
                sym = ((Elf32_Sym *)symsec->sh_addr) + offset;
                symname = strtab + sym->st_name;

-               if (rel->r_offset < 0 || rel->r_offset >
dstsec->sh_size - sizeof(u32)) {
+               if (rel->r_offset > dstsec->sh_size - sizeof(u32)) {
                        pr_err("%s: section %u reloc %u sym '%s': out
of bounds relocation, offset %d size %u\n",
                               module->name, relindex, i, symname,
                               rel->r_offset, dstsec->sh_size);
