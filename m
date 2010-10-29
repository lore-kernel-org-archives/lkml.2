Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360Ab0J2PEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:04:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841Ab0J2PEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:04:21 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Modules: x86_64 - R_X86_64_PC32 gives signed 32 bit and needs overflow check.
Date: Fri, 29 Oct 2010 20:37:32 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, x86@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010292037.32588.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

R_X86_64_PC32 gives signed 32 bit and needs overflow check.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 8f29560..59b859a 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -168,11 +168,9 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			break;
 		case R_X86_64_PC32:
 			val -= (u64)loc;
-			*(u32 *)loc = val;
-#if 0
+			*(s32 *)loc = val;
 			if ((s64)val != *(s32 *)loc)
 				goto overflow;
-#endif
 			break;
 		default:
 			printk(KERN_ERR "module %s: Unknown rela relocation: %llu\n",
