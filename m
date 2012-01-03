Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2ACXFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:05:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab2ACWgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:36:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:34 2012
Message-Id: <20120103223034.227633002@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ulf Hansson <ulf.hansson@stericsson.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [34/67] ARM: 7214/1: mmc: mmci: Fixup handling of MCI_STARTBITERR
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@stericsson.com>

commit b63038d6f4ca5d1849ce01d9fc5bb9cb426dec73 upstream.

The interrupt was previously enabled and then correctly cleared.
Now we also handle it correctly.

Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@stericsson.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/mmci.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -557,7 +557,8 @@ mmci_data_irq(struct mmci_host *host, st
 	      unsigned int status)
 {
 	/* First check for errors */
-	if (status & (MCI_DATACRCFAIL|MCI_DATATIMEOUT|MCI_TXUNDERRUN|MCI_RXOVERRUN)) {
+	if (status & (MCI_DATACRCFAIL|MCI_DATATIMEOUT|MCI_STARTBITERR|
+		      MCI_TXUNDERRUN|MCI_RXOVERRUN)) {
 		u32 remain, success;
 
 		/* Terminate the DMA transfer */
@@ -837,8 +838,9 @@ static irqreturn_t mmci_irq(int irq, voi
 		dev_dbg(mmc_dev(host->mmc), "irq0 (data+cmd) %08x\n", status);
 
 		data = host->data;
-		if (status & (MCI_DATACRCFAIL|MCI_DATATIMEOUT|MCI_TXUNDERRUN|
-			      MCI_RXOVERRUN|MCI_DATAEND|MCI_DATABLOCKEND) && data)
+		if (status & (MCI_DATACRCFAIL|MCI_DATATIMEOUT|MCI_STARTBITERR|
+			      MCI_TXUNDERRUN|MCI_RXOVERRUN|MCI_DATAEND|
+			      MCI_DATABLOCKEND) && data)
 			mmci_data_irq(host, data, status);
 
 		cmd = host->cmd;


