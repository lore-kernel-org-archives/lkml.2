Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab2DSVFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:05:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab2DSVF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:05:27 -0400
Message-Id: <20120419210303.989795783@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 10/75] ARM: 7379/1: DT: fix atags_to_fdt() second call site
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <Marc.Zyngier@arm.com>

commit 9c5fd9e85f574d9d0361b2b878f55732290afe5b upstream.

atags_to_fdt() returns 1 when it fails to find a valid FDT signature.
The CONFIG_ARM_ATAG_DTB_COMPAT code is supposed to retry with another
location, but only does so when the initial call doesn't fail.

Fix this by using the correct condition in the assembly code.

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/compressed/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -273,7 +273,7 @@ restart:	adr	r0, LC0
 		add	r0, r0, #0x100
 		mov	r1, r6
 		sub	r2, sp, r6
-		blne	atags_to_fdt
+		bleq	atags_to_fdt
 
 		ldmfd	sp!, {r0-r3, ip, lr}
 		sub	sp, sp, #0x10000


