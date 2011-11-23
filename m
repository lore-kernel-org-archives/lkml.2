Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab1KWAlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:41:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237Ab1KWAlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:05 2011
Message-Id: <20111123002405.279436121@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [07/53] ARM: 7150/1: Allow kernel unaligned accesses on ARMv6+
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------
 processors

From: Catalin Marinas <catalin.marinas@arm.com>

commit 8428e84d42179c2a00f5f6450866e70d802d1d05 upstream.

Recent gcc versions generate unaligned accesses by default on ARMv6 and
later processors. This patch ensures that the SCTLR.A bit is always
cleared on such processors to avoid kernel traping before
alignment_init() is called.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: John Linn <John.Linn@xilinx.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -348,7 +348,7 @@ __secondary_data:
  *  r13 = *virtual* address to jump to upon completion
  */
 __enable_mmu:
-#ifdef CONFIG_ALIGNMENT_TRAP
+#if defined(CONFIG_ALIGNMENT_TRAP) && __LINUX_ARM_ARCH__ < 6
 	orr	r0, r0, #CR_A
 #else
 	bic	r0, r0, #CR_A


