Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab2CDNYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 08:24:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43664 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2CDNYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 08:24:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Mar 2012 14:24:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: tone down some diagnostic log messages
Message-ID: <20120304142431.337875c2@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "skipped bus generations" message was added together with the
respective fw_device retaining/ reviving code in order to see how it all
works out.  It did well, so don't spam the log anymore.

The "register access failure" situation still needs an actual handler.
But at this point it makes less sense to ask folks to send mails about
it.  We now have a pretty good picture of what controllers emit this and
when:

Texas Instruments PCIxx21 FireWire + CardBus + flash memory card
controller:
https://bugzilla.redhat.com/show_bug.cgi?id=608544

O2 Micro FireWire + flash memory card controller:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/801719
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881688
http://marc.info/?l=linux1394-devel&m=132309283531423
http://marc.info/?l=linux1394-devel&m=132368567907469
http://marc.info/?l=linux1394-devel&m=132516165727468
http://marc.info/?l=linux1394-devel&m=133006486927699

Pinnacle Movieboard:
commit 7f7e37115a8b6724f26d0637a04e1d35e3c59717
http://marc.info/?l=linux1394-devel&m=130714243325962

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-topology.c |    1 -
 drivers/firewire/ohci.c          |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -530,7 +530,6 @@ void fw_core_handle_bus_reset(struct fw_
 	 */
 	if (!is_next_generation(generation, card->generation) &&
 	    card->local_node != NULL) {
-		fw_notice(card, "skipped bus generations, destroying all nodes\n");
 		fw_destroy_nodes(card);
 		card->bm_retries = 0;
 	}
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2080,8 +2080,7 @@ static irqreturn_t irq_handler(int irq,
 	}
 
 	if (unlikely(event & OHCI1394_regAccessFail))
-		dev_err(ohci->card.device,
-			"register access failure - please notify linux1394-devel@lists.sf.net\n");
+		dev_err(ohci->card.device, "register access failure\n");
 
 	if (unlikely(event & OHCI1394_postedWriteErr)) {
 		reg_read(ohci, OHCI1394_PostedWriteAddressHi);


-- 
Stefan Richter
-=====-===-- --== --=--
http://arcgraph.de/sr/
