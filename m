Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab1AKLVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:21:20 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41892 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab1AKLVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:21:18 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] Fix Moorestown VRTC fixmap placement
To: x86@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Jan 2011 10:55:56 +0000
Message-ID: <20110111105544.24448.27607.stgit@bob.linux.org.uk>
In-Reply-To: <20110111105439.24448.69863.stgit@bob.linux.org.uk>
References: <20110111105439.24448.69863.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

The x86 fixmaps need to be all together... unfortunately the VRTC one
was misplaced.

This patch makes sure the MRST VRTC fixmap is put prior to the
__end_of_permanent_fixed_addresses marker.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/include/asm/fixmap.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 0141b23..4729b2b 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -116,11 +116,11 @@ enum fixed_addresses {
 #endif
 	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
 	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
-	__end_of_permanent_fixed_addresses,
-
 #ifdef	CONFIG_X86_MRST
 	FIX_LNW_VRTC,
 #endif
+	__end_of_permanent_fixed_addresses,
+
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.

