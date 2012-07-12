Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab2GLWgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:36:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab2GLWgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 008/187] powerpc/pseries: Fix software invalidate TCE
Date: Thu, 12 Jul 2012 15:32:44 -0700
Message-Id: <20120712191523.011159357@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit bc6dc752f35488160ffac07ae91bed1bddaea32a upstream.

The following added support for powernv but broke pseries/BML:
 1f1616e powerpc/powernv: Add TCE SW invalidation support

TCE_PCI_SW_INVAL was split into FREE and CREATE flags but the tests in
the pseries code were not updated to reflect this.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -106,7 +106,7 @@ static int tce_build_pSeries(struct iomm
 		tcep++;
 	}
 
-	if (tbl->it_type == TCE_PCI_SWINV_CREATE)
+	if (tbl->it_type & TCE_PCI_SWINV_CREATE)
 		tce_invalidate_pSeries_sw(tbl, tces, tcep - 1);
 	return 0;
 }
@@ -121,7 +121,7 @@ static void tce_free_pSeries(struct iomm
 	while (npages--)
 		*(tcep++) = 0;
 
-	if (tbl->it_type == TCE_PCI_SWINV_FREE)
+	if (tbl->it_type & TCE_PCI_SWINV_FREE)
 		tce_invalidate_pSeries_sw(tbl, tces, tcep - 1);
 }
 


