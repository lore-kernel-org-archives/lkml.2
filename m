Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0LGOtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:49:19 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:34751 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0LGOtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:49:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=lKGq2PFR2I0ktMHP+rPJgn/FxvFZ9rMS5R/F+nxK3qtw697tuS49wju9Cz2LRe39rB
         I97pkoz/4SphIIXJCAAUm5Sv3BhPABwv8eEjOmWXtnoZNkucdBtOvqZw8jfCAmtmee0y
         hE5JiYORnhYVFGeGFYD3g0S725AtRVPQRTPFY=
From: Namhyung Kim <namhyung@gmail.com>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isdn/hisax: fix compiler warning on hisax_pci_tbl
Date: Tue,  7 Dec 2010 23:49:06 +0900
Message-Id: <1291733346-11573-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate hisax_pci_tbl as '__used' to fix following warning:

  CC      drivers/isdn/hisax/config.o
drivers/isdn/hisax/config.c:1920: warning: ‘hisax_pci_tbl’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/isdn/hisax/config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index b133378..c110f86 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1917,7 +1917,7 @@ static void EChannel_proc_rcv(struct hisax_d_if *d_if)
 #ifdef CONFIG_PCI
 #include <linux/pci.h>
 
-static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
+static struct pci_device_id hisax_pci_tbl[] __devinitdata __used = {
 #ifdef CONFIG_HISAX_FRITZPCI
 	{PCI_VDEVICE(AVM,      PCI_DEVICE_ID_AVM_A1)			},
 #endif
-- 
1.7.0.4

