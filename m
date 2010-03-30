Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab0CaATA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:19:00 -0400
Received: from kroah.org ([198.145.64.141]:51707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642Ab0C3XRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:23 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:55:59 2010
Message-Id: <20100330225558.997618252@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [005/116] MIPS: Cleanup forgotten label_module_alloc in tlbex.c
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Daney <ddaney@caviumnetworks.com>

commit abbdc3d88aa2d5c937b21044c336bcd056c1732f upstream.

commit c8af165342e83a4eb078c9607d29a7c399d30a53 (lmo) rsp.
e0cc87f59490d7d62a8ab2a76498dc8a2b64927a (kernel.org) left
label_module_alloc unused.  Remove it now.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org
Patchwork: http://patchwork.linux-mips.org/patch/752/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/mm/tlbex.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -73,9 +73,6 @@ static int __cpuinit m4kc_tlbp_war(void)
 enum label_id {
 	label_second_part = 1,
 	label_leave,
-#ifdef MODULE_START
-	label_module_alloc,
-#endif
 	label_vmalloc,
 	label_vmalloc_done,
 	label_tlbw_hazard,
@@ -92,9 +89,6 @@ enum label_id {
 
 UASM_L_LA(_second_part)
 UASM_L_LA(_leave)
-#ifdef MODULE_START
-UASM_L_LA(_module_alloc)
-#endif
 UASM_L_LA(_vmalloc)
 UASM_L_LA(_vmalloc_done)
 UASM_L_LA(_tlbw_hazard)
@@ -802,8 +796,6 @@ static void __cpuinit build_r4000_tlb_re
 	} else {
 #if defined(CONFIG_HUGETLB_PAGE)
 		const enum label_id ls = label_tlb_huge_update;
-#elif defined(MODULE_START)
-		const enum label_id ls = label_module_alloc;
 #else
 		const enum label_id ls = label_vmalloc;
 #endif


