Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0LHAvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:51:10 -0500
Received: from kroah.org ([198.145.64.141]:58696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab0LHAsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:15 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:35 2010
Message-Id: <20101208004435.722240614@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:45:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [114/127] x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit b7d460897739e02f186425b7276e3fdb1595cea7 upstream.

rc2 kernel crashes when booting second cpu on this CONFIG_VMSPLIT_2G_OPT
laptop: whereas cloning from kernel to low mappings pgd range does need
to limit by both KERNEL_PGD_PTRS and KERNEL_PGD_BOUNDARY, cloning kernel
pgd range itself must not be limited by the smaller KERNEL_PGD_BOUNDARY.

Signed-off-by: Hugh Dickins <hughd@google.com>
LKML-Reference: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/kernel/trampoline.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -47,8 +47,7 @@ void __init setup_trampoline_page_table(
 	/* Copy kernel address range */
 	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
 			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			min_t(unsigned long, KERNEL_PGD_PTRS,
-			      KERNEL_PGD_BOUNDARY));
+			KERNEL_PGD_PTRS);
 
 	/* Initialize low mappings */
 	clone_pgd_range(trampoline_pg_dir,


