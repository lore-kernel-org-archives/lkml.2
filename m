Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2DSOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 10:09:58 -0400
Received: from nm17-vm1.bullet.mail.ird.yahoo.com ([77.238.189.206]:40873 "HELO
	nm17-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752363Ab2DSOJ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:09:56 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 917624.25381.bm@omp1007.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=CJQGW+9FDBj6ZNtPawu/rtfdCWSgSvDt5dn1K3tNEZ6i3F0IPWprbOtosbjYJP9yBsnZcnfl78SNMlfYOeXa9G3sJHdQKowVdZq/F+BU3AVzN7GreOVxP++rI6uvjJIWzOzvsYlBqLk5mhk0LTeqs3BGH/42fqV+V7QUZ/BKrQU=;
X-YMail-OSG: lwzE.3gVM1m3uUVyy4dcQ7IKNh4ywkhpY3PMDCR517z8ITu
 lQFH9EgjXR2kChMwxAMAYLR_kyhzCqtYSCbSGY29H68HYRV7nGC_nMS9jXLo
 mmyTa1_YHM4wM9d3nL1dzjurMvYihd5U6a2NvtPczwOjkp7rltj5xqSJhuUJ
 9plxu.hURnDy37OQOC7RF8q01q8BRo8Xay0n9ZbJYIxAprHqCB5zZF8r4aRB
 z2gI_j_rNlnP4o.N0U3wLhQqZA109.RBmPEZrFTxVjeZuUoavuK79.rrjUcZ
 u14frDo9GDPik7gc_95X2.Ol_LPQQPFArrTiYwYK1tCijySNRCCj0azq.KJL
 w_kfzvjlorqCPwz40X7AR7ibqKUmYhR53JBaI1xPo8sxoQ5XQz.2QcZTxQRJ
 kX.UWNGs.OFvvaDfmaNBczKxEgkp44Tju6jF5ltdNsihc3OrcTsPVzsaIyeQ
 oxZRvlYBEFcrZHcFeRhKSFo0VT13lG85ZfqJL4fef2QipIyH8M63kMWizLYd
 w7ISAmmX2duj8R9ndpqxd6pZpTw50v0xQEZv7TXEsl7hPjMPcD.0U7CrbjGr
 ENupvBSG8Z4ZyblyhYa_1sCkH0TARluWwVoFsyzGiNq6twbLeHTA0waLSWxl
 vkHY4CwwRf2gimZhkmfSbn1eNWjbczv3ZzTcSAd0omlczKaLdEkTl019bNSE
 xxyYZTmtdTbpS6hH9HElHGCFRwti6BDADuYpqlXf16dgOUMf7EyuXvZNBsTl
 V1IoGIALn6Nw5ItUH9aEfXbSvcX3zAQU-
X-Mailer: YahooMailClassic/15.0.5 YahooMailWebService/0.8.117.340979
Message-ID: <1334844594.62458.YahooMailClassic@web29011.mail.ird.yahoo.com>
Date: Thu, 19 Apr 2012 15:09:54 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: [PATCH] video: w100fb: Reduce sleep mode battery discharge
To: FlorianSchandinat@gmx.de
Cc: mreimer@sdgsystems.com, philipp.zabel@gmail.com,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2006 and 2007 the handhelds.org kernel w100fb driver was patched to
reduce sleep mode battery discharge. Unfortunately those two patches
never migrated to the mainline kernel.

Fortunately the function affected - w100_suspend() - has not changed
since; thus those patches still apply cleanly.

Applying those patches to linux-3.4-rc3 running on an HP iPAQ hx4700
reduces the sleep mode battery discharge from approximately 26 mA to
approximately 11 mA.

This patch combines those two patches into a single unified patch.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
Cc: Matt Reimer <mreimer@sdgsystems.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
---

Many thanks to Matt Reimer for suggesting this.

The seeming demise of handhelds.org has removed any formal patch logs.
However the patches can still be viewed online:
2006 patch:
http://paste.lisp.org/display/31700
2007 patch:
http://osdir.com/ml/handhelds.linux.kernel/2007-02/msg00020.html

And the fully patched handhelds.org kernel is still available, e.g.:
http://www.linuxtogo.org/~goxboxlive/htcuniversal/Kernel/linux-2.6.21-hh20.tar.bz2

 drivers/video/w100fb.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index 90a2e30..2f6b2b8 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -1567,6 +1567,18 @@ static void w100_suspend(u32 mode)
 		val = readl(remapped_regs + mmPLL_CNTL);
 		val |= 0x00000004;  /* bit2=1 */
 		writel(val, remapped_regs + mmPLL_CNTL);
+
+		writel(0x00000000, remapped_regs + mmLCDD_CNTL1);
+		writel(0x00000000, remapped_regs + mmLCDD_CNTL2);
+		writel(0x00000000, remapped_regs + mmGENLCD_CNTL1);
+		writel(0x00000000, remapped_regs + mmGENLCD_CNTL2);
+		writel(0x00000000, remapped_regs + mmGENLCD_CNTL3);
+
+		val = readl(remapped_regs + mmMEM_EXT_CNTL);
+		val |= 0xF0000000;
+		val &= ~(0x00000001);
+		writel(val, remapped_regs + mmMEM_EXT_CNTL);
+
 		writel(0x0000001d, remapped_regs + mmPWRMGT_CNTL);
 	}
 }
-- 
1.7.3.4

