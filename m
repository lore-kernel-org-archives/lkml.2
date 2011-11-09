Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935026Ab1KJD24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:28:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934999Ab1KJD2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212717.173462118@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arvid Brodin <arvid.brodin@enea.com>
Subject: [165/262] usb/isp1760: Added missing call to usb_hcd_check_unlink_urb() during unlink
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvid Brodin <arvid.brodin@enea.com>

commit 17d3e145a4ad680b3d1b1c30d0696a5bbb2b65c4 upstream.

Signed-off-by: Arvid Brodin <arvid.brodin@enea.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/isp1760-hcd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -1583,6 +1583,9 @@ static int isp1760_urb_dequeue(struct us
 	int retval = 0;
 
 	spin_lock_irqsave(&priv->lock, spinflags);
+	retval = usb_hcd_check_unlink_urb(hcd, urb, status);
+	if (retval)
+		goto out;
 
 	qh = urb->ep->hcpriv;
 	if (!qh) {


