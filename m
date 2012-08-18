Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2HRBRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:17:35 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:57937 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2HRBR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:17:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1345252645!8750628!14
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/20] staging: comedi: adv_pci1723: remove range_pci1723
Date: Fri, 17 Aug 2012 18:17:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171817.14350.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comedi_lrange is the same as the global range_bipolar10
exported by the comedi core. Use that range instead.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1723.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index cc67dccb..a790bb7 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -114,11 +114,6 @@ TODO:
 
 /* static unsigned short pci_list_builded=0;      =1 list of card is know */
 
-static const struct comedi_lrange range_pci1723 = { 1, {
-							BIP_RANGE(10)
-							}
-};
-
 /*
  * Board descriptions for pci1723 boards.
  */
@@ -144,7 +139,7 @@ static const struct pci1723_board boardtypes[] = {
 	 .n_aochan = 8,
 	 .n_diochan = 16,
 	 .ao_maxdata = 0xffff,
-	 .rangelist_ao = &range_pci1723,
+	 .rangelist_ao = &range_bipolar10,
 	 },
 };
 
-- 
1.7.11

