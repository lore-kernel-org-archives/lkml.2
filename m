Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab1KCCGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:06:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab1KCBhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.735991787@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anand Gadiyar <gadiyar@ti.com>,
        Ajay Kumar Gupta <ajay.gupta@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [094/107] Revert "usb: musb: restore INDEX register in resume path"
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

This reverts commit 262e2d9d559334e09bc80516132ea99d82f97b8c.

Turns out this breaks the build, and as such, really isn't needed for
the 2.6.32-stable branch at all.

Reported-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Anand Gadiyar <gadiyar@ti.com>
Cc: Ajay Kumar Gupta <ajay.gupta@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1634,7 +1634,6 @@ void musb_dma_completion(struct musb *mu
 			}
 		}
 	}
-	musb_writeb(musb_base, MUSB_INDEX, musb->context.index);
 }
 
 #else


