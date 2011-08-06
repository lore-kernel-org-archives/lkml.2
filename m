Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1HFL1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 07:27:05 -0400
Received: from www17.your-server.de ([213.133.104.17]:34679 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1HFL1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 07:27:01 -0400
Subject: [PATCH] staging: brcm80211: use kzalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 06 Aug 2011 13:26:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312629992.5589.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>


 Use kzalloc rather than kmalloc followed by memset with 0

 This considers some simple cases that are common and easy to validate
 Note in particular that there are no ...s in the rule, so all of the
 matched code has to be contiguous

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c 2011-07-28 15:32:17.863253745 +0200
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c 2011-08-01 20:25:55.608031978 +0200
@@ -6326,14 +6326,12 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bu
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* alloc chip_info_t */
-	ci = kmalloc(sizeof(struct chip_info), GFP_ATOMIC);
+	ci = kzalloc(sizeof(struct chip_info), GFP_ATOMIC);
 	if (NULL == ci) {
 		BRCMF_ERROR(("%s: malloc failed!\n", __func__));
 		return -ENOMEM;
 	}
 
-	memset((unsigned char *)ci, 0, sizeof(struct chip_info));
-
 	/* bus/core/clk setup for register access */
 	/* Try forcing SDIO core to do ALPAvail request only */
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;



