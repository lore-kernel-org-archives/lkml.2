Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0EXXXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:23:46 -0400
Received: from kroah.org ([198.145.64.141]:59356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab0EXXXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:32 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:14 2010
Message-Id: <20100524231814.097165007@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, <linux-mmc@vger.kernel.org>
Subject: [10/39] mmc: atmel-mci: fix two parameters swapped
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit ebb1fea9b3adf25d7e2f643c614163af4f93a17f upstream.

Two parameters were swapped in the calls to atmci_init_slot().

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reported-by: Anders Grahn <anders.grahn@hd-wireless.se>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/atmel-mci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1750,13 +1750,13 @@ static int __init atmci_probe(struct pla
 	ret = -ENODEV;
 	if (pdata->slot[0].bus_width) {
 		ret = atmci_init_slot(host, &pdata->slot[0],
-				MCI_SDCSEL_SLOT_A, 0);
+				0, MCI_SDCSEL_SLOT_A);
 		if (!ret)
 			nr_slots++;
 	}
 	if (pdata->slot[1].bus_width) {
 		ret = atmci_init_slot(host, &pdata->slot[1],
-				MCI_SDCSEL_SLOT_B, 1);
+				1, MCI_SDCSEL_SLOT_B);
 		if (!ret)
 			nr_slots++;
 	}


