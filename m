Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab0HKXuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:50:14 -0400
Received: from kroah.org ([198.145.64.141]:57561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758498Ab0HKXuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:50:04 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:46:26 2010
Message-Id: <20100811234625.918153689@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:45:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kay Sievers <kay.sievers@vrfy.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [11/11] mm/backing-dev.c: remove recently-added WARN_ON()
In-Reply-To: <20100811234809.GA676@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 69fc208be5b7eb18d22d1eca185b201400fd5ffc upstream.

On second thoughts, this is just going to disturb people while telling us
things which we already knew.

Cc: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -176,7 +176,7 @@ int bdi_register(struct backing_dev_info
 	int ret = 0;
 	struct device *dev;
 
-	if (WARN_ON(bdi->dev))
+	if (bdi->dev)	/* The driver needs to use separate queues per device */
 		goto exit;
 
 	va_start(args, fmt);


