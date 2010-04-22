Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0DVTxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:53:48 -0400
Received: from kroah.org ([198.145.64.141]:40862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab0DVT2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:38 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:15 2010
Message-Id: <20100422190914.995825167@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rabin Vincent <rabin@rab.in>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [085/197] ARM: 6031/1: fix Thumb-2 decompressor
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rabin Vincent <rabin@rab.in>

commit d4d9959c099751158c5cf14813fe378e206339c6 upstream.

98e12b5a6e05413 ("ARM: Fix decompressor's kernel size estimation for
ROM=y") broke the Thumb-2 decompressor because it added an entry in the
LC0 table but didn't adjust the offset the Thumb-2 code uses to load the
SP from that table.  Fix it.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/boot/compressed/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -164,7 +164,7 @@ not_angel:
 		adr	r0, LC0
  ARM(		ldmia	r0, {r1, r2, r3, r4, r5, r6, r11, ip, sp})
  THUMB(		ldmia	r0, {r1, r2, r3, r4, r5, r6, r11, ip}	)
- THUMB(		ldr	sp, [r0, #28]				)
+ THUMB(		ldr	sp, [r0, #32]				)
 		subs	r0, r0, r1		@ calculate the delta offset
 
 						@ if delta is zero, we are


