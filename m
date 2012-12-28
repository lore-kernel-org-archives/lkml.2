Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab2L1TTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55589 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932397Ab2L1TTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:32 -0500
Message-Id: <20121228190340.291003035@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 049/173] ARM: mm: use pteval_t to represent page protection values
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 864aa04cd02979c2c755cb28b5f4fe56039171c0 upstream.

When updating the page protection map after calculating the user_pgprot
value, the base protection map is temporarily stored in an unsigned long
type, causing truncation of the protection bits when LPAE is enabled.
This effectively means that calls to mprotect() will corrupt the upper
page attributes, clearing the XN bit unconditionally.

This patch uses pteval_t to store the intermediate protection values,
preserving the upper bits for 64-bit descriptors.

Acked-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -475,7 +475,7 @@ static void __init build_mem_type_table(
 	}
 
 	for (i = 0; i < 16; i++) {
-		unsigned long v = pgprot_val(protection_map[i]);
+		pteval_t v = pgprot_val(protection_map[i]);
 		protection_map[i] = __pgprot(v | user_pgprot);
 	}
 


