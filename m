Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab1LPTwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:52:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab1LPTuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:59 2011
Message-Id: <20111216194559.217174025@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sascha Hauer <s.hauer@pengutronix.de>,
        Chris Ball <cjb@laptop.org>
Subject: [32/53] mmc: mxcmmc: fix falling back to PIO
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit e58f516ff4730c4047c3f104b061f7a03e9a263c upstream.

When we can't configure the dma channel we want to fall
back to PIO. We do this by setting host->do_dma to zero.
This does not work as do_dma is used to see whether dma
can be used for the current transfer. Instead, we have
to set host->dma to NULL.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/mxcmmc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -731,6 +731,7 @@ static void mxcmci_set_ios(struct mmc_ho
 				"failed to config DMA channel. Falling back to PIO\n");
 			dma_release_channel(host->dma);
 			host->do_dma = 0;
+			host->dma = NULL;
 		}
 	}
 


