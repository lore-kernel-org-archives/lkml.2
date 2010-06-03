Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab0FCMOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:14:48 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19310 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0FCMOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:14:47 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: linux@arm.linux.org.uk, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: module - simplify code with temporaries
Date: Thu,  3 Jun 2010 15:17:20 +0300
Message-Id: <1275567442-11370-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1275567442-11370-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1275567442-11370-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-OriginalArrivalTime: 03 Jun 2010 12:14:24.0354 (UTC) FILETIME=[4E089420:01CB0316]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Less to read.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 arch/arm/kernel/module.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index c628bdf..d531a63 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -71,17 +71,19 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
 	Elf_Shdr *s, *sechdrs_end = sechdrs + hdr->e_shnum;
 
 	for (s = sechdrs; s < sechdrs_end; s++) {
-		if (strcmp(".ARM.exidx.init.text", secstrings + s->sh_name) == 0)
+		char const *secname = secstrings + s->sh_name;
+
+		if (strcmp(".ARM.exidx.init.text", secname) == 0)
 			mod->arch.unw_sec_init = s;
-		else if (strcmp(".ARM.exidx.devinit.text", secstrings + s->sh_name) == 0)
+		else if (strcmp(".ARM.exidx.devinit.text", secname) == 0)
 			mod->arch.unw_sec_devinit = s;
-		else if (strcmp(".ARM.exidx", secstrings + s->sh_name) == 0)
+		else if (strcmp(".ARM.exidx", secname) == 0)
 			mod->arch.unw_sec_core = s;
-		else if (strcmp(".init.text", secstrings + s->sh_name) == 0)
+		else if (strcmp(".init.text", secname) == 0)
 			mod->arch.sec_init_text = s;
-		else if (strcmp(".devinit.text", secstrings + s->sh_name) == 0)
+		else if (strcmp(".devinit.text", secname) == 0)
 			mod->arch.sec_devinit_text = s;
-		else if (strcmp(".text", secstrings + s->sh_name) == 0)
+		else if (strcmp(".text", secname) == 0)
 			mod->arch.sec_core_text = s;
 	}
 #endif
-- 
1.6.0.4

