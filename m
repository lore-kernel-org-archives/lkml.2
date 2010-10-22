Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab0JVTA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:00:29 -0400
Received: from kroah.org ([198.145.64.141]:34494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759493Ab0JVS5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:15 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:36 2010
Message-Id: <20101022185236.107057159@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:52:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [098/103] x86-32: Fix dummy trampoline-related inline stubs
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 8848a91068c018bc91f597038a0f41462a0f88a4 upstream.

Fix dummy inline stubs for trampoline-related functions when no
trampolines exist (until we get rid of the no-trampoline case
entirely.)

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <4C6C294D.3030404@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/trampoline.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -22,8 +22,8 @@ extern unsigned long setup_trampoline(vo
 extern void __init setup_trampoline_page_table(void);
 extern void __init reserve_trampoline_memory(void);
 #else
-static inline void reserve_trampoline_memory(void) {};
-extern void __init setup_trampoline_page_table(void) {};
+static inline void setup_trampoline_page_table(void) {}
+static inline void reserve_trampoline_memory(void) {}
 #endif /* CONFIG_X86_TRAMPOLINE */
 
 #endif /* __ASSEMBLY__ */


