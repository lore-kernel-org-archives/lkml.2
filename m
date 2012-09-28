Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032993Ab2I1UrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:47:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33402 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032931Ab2I1UrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:47:00 -0400
X-Sasl-enc: o8PRQfE887J2vNzqZZ40a6aVvWSksQz+c+aSaBJ1DCdX 1348865220
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Pitre <nico@fluxnic.net>, Will Deacon <will.deacon@arm.com>,
        Matthew Leach <matthew.leach@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 059/127] ARM: 7532/1: decompressor: reset SCTLR.TRE for VMSA ARMv7 cores
Date: Fri, 28 Sep 2012 13:33:52 -0700
Message-Id: <20120928203052.738975096@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Leach <matthew.leach@arm.com>

commit e1e5b7e4251c7538ca08c2c5545b0c2fbd8a6635 upstream.

This patch zeroes the SCTLR.TRE bit prior to setting the mapping as
cacheable for ARMv7 cores in the decompressor, ensuring that the
memory region attributes are obtained from the C and B bits, not from
the page tables.

Cc: Nicolas Pitre <nico@fluxnic.net>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/compressed/head.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -539,6 +539,7 @@ __armv7_mmu_cache_on:
 		mcrne	p15, 0, r0, c8, c7, 0	@ flush I,D TLBs
 #endif
 		mrc	p15, 0, r0, c1, c0, 0	@ read control reg
+		bic	r0, r0, #1 << 28	@ clear SCTLR.TRE
 		orr	r0, r0, #0x5000		@ I-cache enable, RR cache replacement
 		orr	r0, r0, #0x003c		@ write buffer
 #ifdef CONFIG_MMU


