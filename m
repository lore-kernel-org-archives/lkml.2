Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1I1WjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab1I1WjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:30 2011
Message-Id: <20110928220130.113258236@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [046/244] sparc64: Only Panther cheetah+ chips have POPC.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 1a8e0da5937a6c87807083baa318cf8f98dac9aa upstream.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/setup_64.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -440,8 +440,14 @@ static void __init init_sparc64_elf_hwca
 			cap |= AV_SPARC_VIS;
 		if (tlb_type == cheetah || tlb_type == cheetah_plus)
 			cap |= AV_SPARC_VIS | AV_SPARC_VIS2;
-		if (tlb_type == cheetah_plus)
-			cap |= AV_SPARC_POPC;
+		if (tlb_type == cheetah_plus) {
+			unsigned long impl, ver;
+
+			__asm__ __volatile__("rdpr %%ver, %0" : "=r" (ver));
+			impl = ((ver >> 32) & 0xffff);
+			if (impl == PANTHER_IMPL)
+				cap |= AV_SPARC_POPC;
+		}
 		if (tlb_type == hypervisor) {
 			if (sun4v_chip_type == SUN4V_CHIP_NIAGARA1)
 				cap |= AV_SPARC_ASI_BLK_INIT;


