Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2BAVJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:09:53 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36568 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757243Ab2BAVJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:45 -0500
X-Sasl-enc: xofO0GT3TB+Wl1iLHxsEFxRI7VaXiIaQd6SbZUNaWMG3 1328130583
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:46 2012
Message-Id: <20120201210046.023013865@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russ Anderson <rja@sgi.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [24/89] x86/uv: Fix uv_gpa_to_soc_phys_ram() shift
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Anderson <rja@sgi.com>

commit 5a51467b146ab7948d2f6812892eac120a30529c upstream.

uv_gpa_to_soc_phys_ram() was inadvertently ignoring the
shift values.  This fix takes the shift into account.

Signed-off-by: Russ Anderson <rja@sgi.com>
Link: http://lkml.kernel.org/r/20120119020753.GA7228@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/uv/uv_hub.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -318,13 +318,13 @@ uv_gpa_in_mmr_space(unsigned long gpa)
 /* UV global physical address --> socket phys RAM */
 static inline unsigned long uv_gpa_to_soc_phys_ram(unsigned long gpa)
 {
-	unsigned long paddr = gpa & uv_hub_info->gpa_mask;
+	unsigned long paddr;
 	unsigned long remap_base = uv_hub_info->lowmem_remap_base;
 	unsigned long remap_top =  uv_hub_info->lowmem_remap_top;
 
 	gpa = ((gpa << uv_hub_info->m_shift) >> uv_hub_info->m_shift) |
 		((gpa >> uv_hub_info->n_lshift) << uv_hub_info->m_val);
-	gpa = gpa & uv_hub_info->gpa_mask;
+	paddr = gpa & uv_hub_info->gpa_mask;
 	if (paddr >= remap_base && paddr < remap_base + remap_top)
 		paddr -= remap_base;
 	return paddr;


