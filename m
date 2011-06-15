Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1FOOmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:42:10 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:5154 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1FOOmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:42:08 -0400
Message-Id: <201106151442.p5FEg4ir010298@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 15 Jun 2011 10:35:38 -0400
Subject: [PATCH] arch/tile: remove useless set_fixmap_nocache() macro
To: "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>, "Greg KH" <greg@kroah.com>,
        <brudley@broadcom.com>, <henryp@broadcom.com>, <rvossen@broadcom.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Linus" <torvalds@linux-foundation.org>, <sparclinux@vger.kernel.org>,
        "Linux-Arch" <linux-arch@vger.kernel.org>
In-Reply-To: <20110610160548.529797c7.sfr@canb.auug.org.au>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au><20110609184127.GA2760@kroah.com><20110609192243.GA3980@kroah.com><20110610160548.529797c7.sfr@canb.auug.org.au>
X-OriginalArrivalTime: 15 Jun 2011 14:42:07.0504 (UTC) FILETIME=[669DB100:01CC2B6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TILE doesn't support PAGE_KERNEL_NOCACHE so the macro isn't useful;
it's a copy-and-paste from the first version of this header in 2007.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/fixmap.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/tile/include/asm/fixmap.h b/arch/tile/include/asm/fixmap.h
index 51537ff..c66f793 100644
--- a/arch/tile/include/asm/fixmap.h
+++ b/arch/tile/include/asm/fixmap.h
@@ -75,12 +75,6 @@ extern void __set_fixmap(enum fixed_addresses idx,
 
 #define set_fixmap(idx, phys) \
 		__set_fixmap(idx, phys, PAGE_KERNEL)
-/*
- * Some hardware wants to get fixmapped without caching.
- */
-#define set_fixmap_nocache(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
-
 #define clear_fixmap(idx) \
 		__set_fixmap(idx, 0, __pgprot(0))
 
-- 
1.6.5.2

