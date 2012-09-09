Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab2IIXVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:21:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51554 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437Ab2IIXRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:18 -0400
Message-Id: <20120909224153.511255892@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 19/95] ARM: 7483/1: vfp: only advertise VFPv4 in hwcaps if CONFIG_VFPv3 is
 enabled
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 3d9fb0038a9b02febb01efc79a4a5d97f1822a90 upstream.

VFPv4 support depends on the VFPv3 context save/restore code, so only
advertise support in the hwcaps if the kernel can actually handle it.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/vfp/vfpmodule.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index fb849d0..c834b32 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -719,8 +719,10 @@ static int __init vfp_init(void)
 			if ((fmrx(MVFR1) & 0x000fff00) == 0x00011100)
 				elf_hwcap |= HWCAP_NEON;
 #endif
+#ifdef CONFIG_VFPv3
 			if ((fmrx(MVFR1) & 0xf0000000) == 0x10000000)
 				elf_hwcap |= HWCAP_VFPv4;
+#endif
 		}
 	}
 	return 0;


