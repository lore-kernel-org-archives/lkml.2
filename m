Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071Ab0G3SNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:13:23 -0400
Received: from kroah.org ([198.145.64.141]:59076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700Ab0G3R5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:16 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:48 2010
Message-Id: <20100730175148.311826817@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>, Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [158/205] isdn/capi: make reset_ctr op truly optional
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 85a83560afa69862639fb2d6f670b4440a003335 upstream.

The CAPI controller operation reset_ctr is marked as optional, and
not all drivers do implement it. Add a check to the kernel CAPI
whether it exists before trying to call it.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/capi/kcapi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -1147,6 +1147,12 @@ load_unlock_out:
 		if (ctr->state == CAPI_CTR_DETECTED)
 			goto reset_unlock_out;
 
+		if (ctr->reset_ctr == NULL) {
+			printk(KERN_DEBUG "kcapi: reset: no reset function\n");
+			retval = -ESRCH;
+			goto reset_unlock_out;
+		}
+
 		ctr->reset_ctr(ctr);
 
 		retval = wait_on_ctr_state(ctr, CAPI_CTR_DETECTED);


