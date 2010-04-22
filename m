Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0DVT3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:29:54 -0400
Received: from kroah.org ([198.145.64.141]:41420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab0DVT3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:36 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:21 2010
Message-Id: <20100422190921.529217881@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <neukum@b1-systems.de>
Subject: [158/197] USB: cdc-acm: Fix stupid NULL pointer in resume()
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit f0730924e9e32bb8935c60040a26d94179355088 upstream.

Stupid logic bug passing a just nulled pointer

Signed-off-by: Oliver Neukum <neukum@b1-systems.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1441,7 +1441,7 @@ static int acm_resume(struct usb_interfa
 			wb = acm->delayed_wb;
 			acm->delayed_wb = NULL;
 			spin_unlock_irq(&acm->write_lock);
-			acm_start_wb(acm, acm->delayed_wb);
+			acm_start_wb(acm, wb);
 		} else {
 			spin_unlock_irq(&acm->write_lock);
 		}


