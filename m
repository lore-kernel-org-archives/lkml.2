Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2E1Dl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:41:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52070 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab2E1D3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:39 -0400
Message-Id: <20120528031210.479274536@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 055/117] USB: cdc-wdm: poll must return POLLHUP if device is gone
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 616b6937e348ef2b4c6ea5fef2cd3c441145efb0 upstream.

Else the poll will be restarted indefinitely in a tight loop,
preventing final device cleanup.

Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 5d15165..7652275 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -548,7 +548,7 @@ static unsigned int wdm_poll(struct file *file, struct poll_table_struct *wait)
 
 	spin_lock_irqsave(&desc->iuspin, flags);
 	if (test_bit(WDM_DISCONNECTING, &desc->flags)) {
-		mask = POLLERR;
+		mask = POLLHUP | POLLERR;
 		spin_unlock_irqrestore(&desc->iuspin, flags);
 		goto desc_out;
 	}


