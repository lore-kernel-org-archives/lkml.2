Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab3AIVtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:49:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:41585 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933047Ab3AIUhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [ 37/47] ARM: mm: use pteval_t to represent page protection values
Date: Wed,  9 Jan 2013 12:35:32 -0800
Message-Id: <20130109201733.766781798@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -467,7 +467,7 @@ static void __init build_mem_type_table(
 	}
 
 	for (i = 0; i < 16; i++) {
-		unsigned long v = pgprot_val(protection_map[i]);
+		pteval_t v = pgprot_val(protection_map[i]);
 		protection_map[i] = __pgprot(v | user_pgprot);
 	}
 


