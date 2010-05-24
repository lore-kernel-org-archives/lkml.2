Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab0EXXa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:30:58 -0400
Received: from kroah.org ([198.145.64.141]:59368 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389Ab0EXXXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:34 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:14 2010
Message-Id: <20100524231814.281230896@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, <linux-mmc@vger.kernel.org>
Subject: [12/39] mmc: atmel-mci: remove data error interrupt after xfer
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit abc2c9fdf636c4335a8d72ac3c5ae152bca44b68 upstream.

Disable data error interrupts while we are actually recording that there
is not such errors.  This will prevent, in some cases, the warning message
printed at new request queuing (in atmci_start_request()).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/atmel-mci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1293,6 +1293,7 @@ static void atmci_tasklet_func(unsigned
 			} else {
 				data->bytes_xfered = data->blocks * data->blksz;
 				data->error = 0;
+				mci_writel(host, IDR, ATMCI_DATA_ERROR_FLAGS);
 			}
 
 			if (!data->stop) {


