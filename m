Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab2CIUQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:16:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030979Ab2CITtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:11 -0500
Message-Id: <20120309190207.658728788@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: [ 66/95] ARM: 7345/1: errata: update workaround for A9 erratum #743622
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit efbc74ace95338484f8d732037b99c7c77098fce upstream.

Erratum #743622 affects all r2 variants of the Cortex-A9 processor, so
ensure that the workaround is applied regardless of the revision.

Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig      |    2 +-
 arch/arm/mm/proc-v7.S |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1272,7 +1272,7 @@ config ARM_ERRATA_743622
 	depends on CPU_V7
 	help
 	  This option enables the workaround for the 743622 Cortex-A9
-	  (r2p0..r2p2) erratum. Under very rare conditions, a faulty
+	  (r2p*) erratum. Under very rare conditions, a faulty
 	  optimisation in the Cortex-A9 Store Buffer may lead to data
 	  corruption. This workaround sets a specific bit in the diagnostic
 	  register of the Cortex-A9 which disables the Store Buffer
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -352,9 +352,7 @@ __v7_setup:
 	mcreq	p15, 0, r10, c15, c0, 1		@ write diagnostic register
 #endif
 #ifdef CONFIG_ARM_ERRATA_743622
-	teq	r6, #0x20			@ present in r2p0
-	teqne	r6, #0x21			@ present in r2p1
-	teqne	r6, #0x22			@ present in r2p2
+	teq	r5, #0x00200000			@ only present in r2p*
 	mrceq	p15, 0, r10, c15, c0, 1		@ read diagnostic register
 	orreq	r10, r10, #1 << 6		@ set bit #6
 	mcreq	p15, 0, r10, c15, c0, 1		@ write diagnostic register


