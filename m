Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab1CZAOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:14:01 -0400
Received: from kroah.org ([198.145.64.141]:35802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933099Ab1CZAGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:56 2011
Message-Id: <20110326000456.240291632@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [04/35] mmc: sdio: remember new card RCA when redetecting card
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>

commit 0aab3995485b8a994bf29a995a008c9ea4a28054 upstream.

During redetection of a SDIO card, a request for a new card RCA
was submitted to the card, but was then overwritten by the old RCA.
This caused the card to be deselected instead of selected when using
the incorrect RCA.  This bug's been present since the "oldcard"
handling was introduced in 2.6.32.

Signed-off-by: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
Reviewed-by: Ulf Hansson <ulf.hansson@stericsson.com>
Reviewed-by: Pawel Wieczorkiewicz <pawel.wieczorkiewicz@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/sdio.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -267,6 +267,14 @@ static int mmc_sdio_init_card(struct mmc
 		if (err)
 			goto remove;
 
+		/*
+		 * Update oldcard with the new RCA received from the SDIO
+		 * device -- we're doing this so that it's updated in the
+		 * "card" struct when oldcard overwrites that later.
+		 */
+		if (oldcard)
+			oldcard->rca = card->rca;
+
 		mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
 	}
 


