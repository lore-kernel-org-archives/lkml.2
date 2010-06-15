Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab0FORKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:10:15 -0400
Received: from rain.florz.de ([62.216.164.86]:37757 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754136Ab0FORKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:10:13 -0400
X-Greylist: delayed 977 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2010 13:10:13 EDT
Date: Tue, 15 Jun 2010 19:10:11 +0200
From: Florian Zumbiehl <florz@florz.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] __ioremap_caller(): make check for ioremapping of RAM
	cover complete mapping
Message-ID: <20100615171011.GB15436@florz.florz.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the patch is untested and someone with detailed understanding of the
semantics of this code probably should check for correctness of
the fixed version in corner cases.

Florian
---------------------------------------------------------------------------
x86 __ioremap_caller(): fix check for overlap with RAM to check the
last page of the mapping as well.

Signed-off-by: Florian Zumbiehl <florz@florz.de>

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index a4643e5..4c3e4f9 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -101,7 +101,7 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	for (pfn = phys_addr >> PAGE_SHIFT;
-				(pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
+				pfn <= (last_addr >> PAGE_SHIFT);
 				pfn++) {
 
 		int is_ram = page_is_ram(pfn);
