Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab0DVULq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:11:46 -0400
Received: from kroah.org ([198.145.64.141]:59994 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111Ab0DVUBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:37 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:16 2010
Message-Id: <20100422195416.570781253@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <neukum@b1-systems.de>
Subject: [111/139] USB: cdc-acm: Fix stupid NULL pointer in resume()
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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


