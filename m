Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab1LHEBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:01:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41730 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab1LHEBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:01:14 -0500
Date: Thu, 8 Dec 2011 12:00:27 +0800
From: Wang YanQing <udknight@gmail.com>
To: dyoung@redhat.com
Cc: trivial <trivial@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCHv2][TRIVIAL] mainline: Fix typo: change aera to area,
 exntension to extension in "*.[ch]"
Message-ID: <20111208040027.GA20036@udknight.homenetwork>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>, dyoung@redhat.com,
	trivial <trivial@kernel.org>, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shell command below make this patch:
find . -name "*.[ch]" | xargs grep -l -w "aera" | xargs sed -i s/aera/area/g
find . -name "*.[ch]" | xargs grep -l -w "exntension" | xargs sed -i s/exntension/extension/g

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 arch/x86/pci/pcbios.c            |    2 +-
 net/ipv4/netfilter/nf_nat_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index db0e9a5..da8fe05 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -44,7 +44,7 @@ static inline void set_bios_x(void)
 	pcibios_enabled = 1;
 	set_memory_x(PAGE_OFFSET + BIOS_BEGIN, (BIOS_END - BIOS_BEGIN) >> PAGE_SHIFT);
 	if (__supported_pte_mask & _PAGE_NX)
-		printk(KERN_INFO "PCI : PCI BIOS aera is rw and x. Use pci=nobios if you want it NX.\n");
+		printk(KERN_INFO "PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.\n");
 }
 
 /*
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 447bc5c..072bb53 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -318,7 +318,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 		srchash = hash_by_src(net, nf_ct_zone(ct),
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		spin_lock_bh(&nf_nat_lock);
-		/* nf_conntrack_alter_reply might re-allocate exntension aera */
+		/* nf_conntrack_alter_reply might re-allocate extension area */
 		nat = nfct_nat(ct);
 		nat->ct = ct;
 		hlist_add_head_rcu(&nat->bysource,
-- 
1.7.3.4

