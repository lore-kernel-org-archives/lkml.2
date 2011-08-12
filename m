Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1HNQNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:13:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab1HNQJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:58 2011
Message-Id: <20110812210558.787825745@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [76/90] sparc: Fix build with DEBUG_PAGEALLOC enabled.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 0785a8e87be0202744d8681363aecbd4ffbb5f5a ]

arch/sparc/mm/init_64.c:1622:22: error: unused variable '__swapper_4m_tsb_phys_patch_end' [-Werror=unused-variable]
arch/sparc/mm/init_64.c:1621:22: error: unused variable '__swapper_4m_tsb_phys_patch' [-Werror=unused-variable]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/mm/init_64.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1618,18 +1618,20 @@ static void ktsb_phys_patch(void)
 {
 	extern unsigned int __swapper_tsb_phys_patch;
 	extern unsigned int __swapper_tsb_phys_patch_end;
-	extern unsigned int __swapper_4m_tsb_phys_patch;
-	extern unsigned int __swapper_4m_tsb_phys_patch_end;
 	unsigned long ktsb_pa;
 
 	ktsb_pa = kern_base + ((unsigned long)&swapper_tsb[0] - KERNBASE);
 	patch_one_ktsb_phys(&__swapper_tsb_phys_patch,
 			    &__swapper_tsb_phys_patch_end, ktsb_pa);
 #ifndef CONFIG_DEBUG_PAGEALLOC
+	{
+	extern unsigned int __swapper_4m_tsb_phys_patch;
+	extern unsigned int __swapper_4m_tsb_phys_patch_end;
 	ktsb_pa = (kern_base +
 		   ((unsigned long)&swapper_4m_tsb[0] - KERNBASE));
 	patch_one_ktsb_phys(&__swapper_4m_tsb_phys_patch,
 			    &__swapper_4m_tsb_phys_patch_end, ktsb_pa);
+	}
 #endif
 }
 


