Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0LAHQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:16:03 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45598 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0LAHQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:16:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gvHmEnlOJdaCp4tq03QF44PD7FhZ7NZ/5LFnHt8D3FyakxmLXkpLwFvzp0Zpoccw3v
         2dxIQbQnRvn7loGK9Fy36Mccv2NHr82/RzHktVzPUVdihAHv6UMz7Ll9vs7NR+fVRkZ/
         ge3kJlehEUwyYSc6cc4SP1PG/AwQSoGNH9nWc=
Subject: [PATCH] ARM: module: fix 'mod' undeclared compile error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain
Date: Wed, 01 Dec 2010 15:21:48 +0800
Message-Id: <1291188108.5563.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 411fdedb4085fc4371f517a77e47e5669479a8a8 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 1 Dec 2010 15:18:18 +0800
Subject: [PATCH] ARM: module: fix 'mod' undeclared compile error

Fix below compile error:

  CC      arch/arm/kernel/module.o
arch/arm/kernel/module.c: In function 'module_finalize':
arch/arm/kernel/module.c:320: error: 'mod' undeclared (first use in this function)
arch/arm/kernel/module.c:320: error: (Each undeclared identifier is reported only once
arch/arm/kernel/module.c:320: error: for each function it appears in.)
make[1]: *** [arch/arm/kernel/module.o] Error 1
make: *** [arch/arm/kernel] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---

This patch fixes the compile error against today's linux-next tree.

Axel

 arch/arm/kernel/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index d03dfe5..0c1bb68 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -277,7 +277,7 @@ struct mod_unwind_map {
 };
 
 int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
-		    struct module *module)
+		    struct module *mod)
 {
 #ifdef CONFIG_ARM_UNWIND
 	const char *secstrs = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
-- 
1.7.2



