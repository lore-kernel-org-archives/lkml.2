Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2AXADX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:03:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab2AWXsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:48:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:26 2012
Message-Id: <20120123234026.156646688@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Girish K S <girish.shivananjappa@linaro.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Philip Rakity <prakity@marvell.com>, Chris Ball <cjb@laptop.org>
Subject: [38/90] mmc: core: Fix voltage select in DDR mode
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Girish K S <girish.shivananjappa@linaro.org>

commit 913047e9e5787a90696533a9f109552b7694ecc9 upstream.

This patch fixes the wrong comparison before setting the interface
voltage in DDR mode.

The assignment to the variable ddr before comaprison is either
ddr = MMC_1_2V_DDR_MODE; or ddr == MMC_1_8V_DDR_MODE. But the comparison
is done with the extended csd value if ddr == EXT_CSD_CARD_TYPE_DDR_1_2V.

Signed-off-by: Girish K S <girish.shivananjappa@linaro.org>
Acked-by: Subhash Jadavani <subhashj@codeaurora.org>
Acked-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -830,7 +830,7 @@ static int mmc_init_card(struct mmc_host
 			 *
 			 * WARNING: eMMC rules are NOT the same as SD DDR
 			 */
-			if (ddr == EXT_CSD_CARD_TYPE_DDR_1_2V) {
+			if (ddr == MMC_1_2V_DDR_MODE) {
 				err = mmc_set_signal_voltage(host,
 					MMC_SIGNAL_VOLTAGE_120, 0);
 				if (err)


