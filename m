Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2ICUPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 16:15:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44271 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2ICUPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 16:15:40 -0400
Date: Mon, 3 Sep 2012 22:15:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix uninitialized variable in ath6kl ath6kl_sdio_enable_scatter
Message-ID: <20120903201536.GA16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.8 warns

/backup/lsrc/git/linux-lto-2.6/drivers/net/wireless/ath/ath6kl/sdio.c:
In function 'ath6kl_sdio_enable_scatter':
/backup/lsrc/git/linux-lto-2.6/drivers/net/wireless/ath/ath6kl/sdio.c:748:16:
warning: 'ret' may be used uninitialized in this function
[-Wmaybe-uninitialized]
  if (virt_scat || ret) {
                ^

The variable can indeed be uninitialized when the previous if branch is
skipped. I just set it to zero for now. I'm not fully sure the fix is
correct, maybe the || should be an && ? 

Signed-off-by: Andi Kleen <ak@linux.intel.com>


diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 05b9540..f495899 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -709,7 +709,7 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct htc_target *target = ar->htc_target;
-	int ret;
+	int ret = 0;
 	bool virt_scat = false;
 
 	if (ar_sdio->scatter_enabled)


-- 
ak@linux.intel.com -- Speaking for myself only.
