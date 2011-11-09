Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834Ab1KJDfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:35:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810Ab1KJDfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:35:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:43 2011
Message-Id: <20111109213143.828056012@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Harro Haan <hrhaan@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [017/264] USB: fix ehci alignment error
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harro Haan <hrhaan@gmail.com>

commit 276532ba9666b36974cbe16f303fc8be99c9da17 upstream.

The Kirkwood gave an unaligned memory access error on
line 742 of drivers/usb/host/echi-hcd.c:
"ehci->last_periodic_enable = ktime_get_real();"

Signed-off-by: Harro Haan <hrhaan@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/usb/hcd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -178,7 +178,7 @@ struct usb_hcd {
 	 * this structure.
 	 */
 	unsigned long hcd_priv[0]
-			__attribute__ ((aligned(sizeof(unsigned long))));
+			__attribute__ ((aligned(sizeof(s64))));
 };
 
 /* 2.4 does this a bit differently ... */


