Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2EIGer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:34:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38655 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793Ab2EIFwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:39 -0400
Message-Id: <20120509055031.688173147@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 015/167] [PATCH] uwb: fix error handling
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 5bd7b419ef2eb4989b207753e088c3437159618a upstream.

Fatal errors such as a device disconnect must not trigger
error handling. The error returns must be checked.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/uwb/hwa-rc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/uwb/hwa-rc.c b/drivers/uwb/hwa-rc.c
index 66797e9..810c90a 100644
--- a/drivers/uwb/hwa-rc.c
+++ b/drivers/uwb/hwa-rc.c
@@ -645,7 +645,8 @@ void hwarc_neep_cb(struct urb *urb)
 		dev_err(dev, "NEEP: URB error %d\n", urb->status);
 	}
 	result = usb_submit_urb(urb, GFP_ATOMIC);
-	if (result < 0) {
+	if (result < 0 && result != -ENODEV && result != -EPERM) {
+		/* ignoring unrecoverable errors */
 		dev_err(dev, "NEEP: Can't resubmit URB (%d) resetting device\n",
 			result);
 		goto error;
-- 
1.7.10



