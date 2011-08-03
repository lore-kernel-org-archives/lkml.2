Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab1HCX3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:29:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab1HCX2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:50 2011
Message-Id: <20110803221250.479789938@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [064/102] cciss: do not attempt to read from a write-only register
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
@@ -223,7 +223,7 @@ static void SA5_submit_command( ctlr_inf
 			h->ctlr, c->busaddr);
 #endif /* CCISS_DEBUG */
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;


