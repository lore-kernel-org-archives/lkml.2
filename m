Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0E3RDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 13:03:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43309 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0E3RDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 13:03:50 -0400
Date: Sun, 30 May 2010 19:03:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100530170346.GC1565@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	user-mode-linux-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <201005271944.09541.toralf.foerster@gmx.de>
 <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
 <20100530150214.GA1565@liondog.tnic>
 <201005301728.25976.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201005301728.25976.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obviously UML cannot stomach callee reg-saving trickery
introduced with d61931d89be506372d01a90d1755f6d0a9fafe2d (x86:
Add optimized popcnt variants) and oopses during boot:
http://marc.info/?l=linux-kernel&m=127522065202435&w=2

Go ahead and fall back to the software hweight* routines on UML.

LKML-Reference: <201005271944.09541.toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/bitops.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 545776e..c9dad12 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -444,7 +444,11 @@ static inline int fls(int x)
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
+#ifdef CONFIG_UML
+#include <asm-generic/bitops/arch_hweight.h>
+#else
 #include <asm/arch_hweight.h>
+#endif
 
 #include <asm-generic/bitops/const_hweight.h>
 
-- 
1.7.1

-- 
Regards/Gruss,
    Boris.
