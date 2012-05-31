Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab2EaU4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:56:43 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:47246 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab2EaU4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:56:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1338497790!8119219!20
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: drivers.c: remove unused inline functions
Date: Thu, 31 May 2012 13:56:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205311356.28582.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the inline functions uvirt_to_kva and kvirt_to_kva, they
are not referenced by any of the drivers.c code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 1c3d638..a0e68f0 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -384,39 +384,6 @@ static int insn_rw_emulate_bits(struct comedi_device *dev,
 	return 1;
 }
 
-static inline unsigned long uvirt_to_kva(pgd_t *pgd, unsigned long adr)
-{
-	unsigned long ret = 0UL;
-	pmd_t *pmd;
-	pte_t *ptep, pte;
-	pud_t *pud;
-
-	if (!pgd_none(*pgd)) {
-		pud = pud_offset(pgd, adr);
-		pmd = pmd_offset(pud, adr);
-		if (!pmd_none(*pmd)) {
-			ptep = pte_offset_kernel(pmd, adr);
-			pte = *ptep;
-			if (pte_present(pte)) {
-				ret = (unsigned long)
-				    page_address(pte_page(pte));
-				ret |= (adr & (PAGE_SIZE - 1));
-			}
-		}
-	}
-	return ret;
-}
-
-static inline unsigned long kvirt_to_kva(unsigned long adr)
-{
-	unsigned long va, kva;
-
-	va = adr;
-	kva = uvirt_to_kva(pgd_offset_k(va), va);
-
-	return kva;
-}
-
 int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		     unsigned long new_size)
 {
