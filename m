Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1G0DVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:21:20 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:50459 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab1G0DVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:21:04 -0400
X-AuditID: 12074422-b7ba7ae000000a14-46-4e2f840d36e8
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 4/5] x86-64/xen: Enable the vvar mapping
Date: Tue, 26 Jul 2011 23:20:38 -0400
Message-Id: <b6598d164fbe64eeea37c0369b64dd6ceaeeb504.1311736366.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsUixCmqrcvbou9n8PQvm0XflaPsFo/mPWK1
	mLpsLqvFssVPGS0u75rDZrH87Dw2ix8bHrNa3Jvynt2Bw2PnrLvsHpsvrmby2LSqk81j8o3l
	jB7b+3axe3x8eovF4/MmuQD2KC6blNSczLLUIn27BK6MhrvpBc84KibdnsPSwDiXvYuRk0NC
	wESi8fcqJghbTOLCvfVsILaQwD5GidszgroYuYDsDYwSX27OZ4FwnjFJ/Nl0kBGkik1ARaJj
	6QOwbhEBJ4nWCR+ZQIqYBZ4xSmw6eoYZJCEsYCEx8V472DoWAVWJ2Q+3g8V5BYIkPrceYoNY
	LSdx5PJzsEGcAgYSeze2MkOcoS+x7stdZlziExgFFjAyrGKUTcmt0s1NzMwpTk3WLU5OzMtL
	LdI11cvNLNFLTSndxAgKZnYXpR2MPw8qHWIU4GBU4uHdGKnvJ8SaWFZcmXuIUZKDSUmUN6MZ
	KMSXlJ9SmZFYnBFfVJqTWnyIUYKDWUmEd8d/PT8h3pTEyqrUonyYlDQHi5I4b4n3f18hgfTE
	ktTs1NSC1CKYrA4Hh8DZ22+5BVpm/w2XYsnLz0tVkuANA1kiWJSanlqRlplTglDOxMEJsowH
	aJk3SA1vcUFibnFmOkT+FKMux935vUcZhcAGSYnzZoMUCYAUZZTmwc2BJalXjOJAbwrzhoBU
	8QATHNykV0BLmEA+0gFbUpKIkJJqYOzT2M5Z1r4tmW/jxGafdXcaj83Z+Dnj3GmBFsHSR0si
	L7X4r/FJKlgS+Hbqnsum+/sVZnLvDOLjsPzRzxS0tW6FzL+v/sFHbnfG3DrHpzVPoMHCKvBR
	gIzfUekvcxf+52ANWvFOrvMGh8WKpE+W1lXqeouTg134/eIFlJ496Jf+tP7m7HsTdimxFGck
	GmoxFxUnAgB7zTjOLQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen needs special treatment for fixmaps.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f987bde..8cce339 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1916,6 +1916,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 # endif
 #else
 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
+	case VVAR_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
 	case FIX_TEXT_POKE1:
@@ -1956,7 +1957,8 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #ifdef CONFIG_X86_64
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
-	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
+	if ((idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) ||
+	    idx == VVAR_PAGE) {
 		unsigned long vaddr = __fix_to_virt(idx);
 		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
 	}
-- 
1.7.6

