Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab2EIFx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38894 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756141Ab2EIFxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:14 -0400
Message-Id: <20120509055038.051604000@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 059/167] [PATCH] usb: dwc3: ep0: increment "actual" on bounced ep0 case
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit cd423dd3634a5232a3019eb372b144619a61cd16 upstream.

due to a HW limitation we have a bounce buffer for ep0
out transfers which are not aligned with MaxPacketSize.

On such case we were not increment r->actual as we should.

This patch fixes that mistake.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/ep0.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -583,9 +583,10 @@ static void dwc3_ep0_complete_data(struc
 		dwc->ep0_bounced = false;
 	} else {
 		transferred = ur->length - trb.length;
-		ur->actual += transferred;
 	}
 
+	ur->actual += transferred;
+
 	if ((epnum & 1) && ur->actual < ur->length) {
 		/* for some reason we did not get everything out */
 


