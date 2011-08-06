Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab1HFAKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:10:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab1HFAKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:10:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:52 2011
Message-Id: <20110806000252.179594779@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [33/55] cciss: do not attempt to read from a write-only register
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 07d0c38e7d84f911c72058a124c7f17b3c779a65 upstream.

Most smartarrays will tolerate it, but some new ones don't.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Note: this is a regression caused by commit 1ddd5049
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/cciss.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -165,7 +165,7 @@ static void SA5_submit_command( ctlr_inf
 	 printk("Sending %x - down to controller\n", c->busaddr );
 #endif /* CCISS_DEBUG */ 
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;


