Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab0HXXDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:20 -0400
Received: from kroah.org ([198.145.64.141]:41261 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933571Ab0HXXDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:04 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:07 2010
Message-Id: <20100824224507.844394167@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tilman Schmidt <tilman@imap.cc>
Subject: [076/114] isdn: gigaset: add missing unlock
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 7e27a0aeb98d53539bdc38384eee899d6db62617 upstream.

We should unlock here.  This is the only place where we return from the
function with the lock held.  The caller isn't expecting it.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/capi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -1044,6 +1044,7 @@ static inline void remove_appl_from_chan
 	do {
 		if (bcap->bcnext == ap) {
 			bcap->bcnext = bcap->bcnext->bcnext;
+			spin_unlock_irqrestore(&bcs->aplock, flags);
 			return;
 		}
 		bcap = bcap->bcnext;


