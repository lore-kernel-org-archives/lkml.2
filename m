Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab1J1X7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:59:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42341 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab1J1X66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:58:58 -0400
From: Julia Lawall <julia@diku.dk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drivers/net/wireless/brcm80211/brcmsmac/dma.c: eliminate a null pointer dereference
Date: Sat, 29 Oct 2011 01:58:14 +0200
Message-Id: <1319846297-2985-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete di->name from the error reporting code, as it is meaningless if di
is NULL.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

if (E == NULL)
{
  ... when != if (E == NULL || ...) S1 else S2
      when != E = E1
*E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index b56a302..1d66f53 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -361,7 +361,7 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 	uint dmactrlflags = di->dma.dmactrlflags;
 
 	if (di == NULL) {
-		DMA_ERROR(("%s: _dma_ctrlflags: NULL dma handle\n", di->name));
+		DMA_ERROR(("_dma_ctrlflags: NULL dma handle\n"));
 		return 0;
 	}
 

