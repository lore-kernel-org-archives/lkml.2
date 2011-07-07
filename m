Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab1GGOae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:30:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61117 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab1GGOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:30:30 -0400
Date: Thu, 7 Jul 2011 09:30:19 -0500
From: Heechul Yun <heechul@illinois.edu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        saeed.bishara@gmail.com
Subject: [PATCHv2] remove unnecessary cache flush on v6 copypage
Message-ID: <20110707143019.GA16819@heechul-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ARM: mm: remove unnecessary cache flush on v6 copypage

Originally introduced to maintain coherency between icache and dcache
in v6 nonaliasing mode. This is now handled by __sync_icache_dcache since
c0177800, therefore unneceary in this function.  

Signed-off-by: Heechul Yun <heechul@illinois.edu>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
--
arch/arm/mm/copypage-v6.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/copypage-v6.c b/arch/arm/mm/copypage-v6.c
index bdba6c6..63cca00 100644
--- a/arch/arm/mm/copypage-v6.c
+++ b/arch/arm/mm/copypage-v6.c
@@ -41,7 +41,6 @@ static void v6_copy_user_highpage_nonaliasing(struct page *to,
 	kfrom = kmap_atomic(from, KM_USER0);
 	kto = kmap_atomic(to, KM_USER1);
 	copy_page(kto, kfrom);
-	__cpuc_flush_dcache_area(kto, PAGE_SIZE);
 	kunmap_atomic(kto, KM_USER1);
 	kunmap_atomic(kfrom, KM_USER0);
 }
