Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab1ESSIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:08:24 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41056 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933939Ab1ESSIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:18 -0400
X-Sasl-enc: piZHZb59yxXJsrTg3VpPHU0FbPtRVaDBXcUjziz6743W 1305828498
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:56 2011
Message-Id: <20110519180556.580362840@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [24/71] ARM: zImage: make sure the stack is 64-bit aligned
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit 3bd2cbb95543acf44fe123eb9f038de54e655eb4 upstream.

With ARMv5+ and EABI, the compiler expects a 64-bit aligned stack so
instructions like STRD and LDRD can be used.  Without this, mysterious
boot failures were seen semi randomly with the LZMA decompressor.

While at it, let's align .bss as well.

Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/boot/compressed/Makefile       |    2 +-
 arch/arm/boot/compressed/vmlinux.lds.in |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -59,7 +59,7 @@ ZTEXTADDR	:= $(CONFIG_ZBOOT_ROM_TEXT)
 ZBSSADDR	:= $(CONFIG_ZBOOT_ROM_BSS)
 else
 ZTEXTADDR	:= 0
-ZBSSADDR	:= ALIGN(4)
+ZBSSADDR	:= ALIGN(8)
 endif
 
 SEDFLAGS	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
--- a/arch/arm/boot/compressed/vmlinux.lds.in
+++ b/arch/arm/boot/compressed/vmlinux.lds.in
@@ -57,6 +57,7 @@ SECTIONS
   .bss			: { *(.bss) }
   _end = .;
 
+  . = ALIGN(8);		/* the stack must be 64-bit aligned */
   .stack		: { *(.stack) }
 
   .stab 0		: { *(.stab) }


