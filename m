Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab2BJWuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:50:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51143 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2BJWuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:13 -0500
MIME-Version: 1.0
Message-Id: <20120210224852.491858082@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [19/21] mmc: cb710 core: Add missing spin_lock_init for irq_lock of struct cb710_chip
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit b5266ea675c5a041e2852c7ccec4cf2d4f5e0cf4 upstream.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/cb710/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/cb710/core.c
+++ b/drivers/misc/cb710/core.c
@@ -244,6 +244,7 @@ static int __devinit cb710_probe(struct
 	if (err)
 		return err;
 
+	spin_lock_init(&chip->irq_lock);
 	chip->pdev = pdev;
 	chip->iobase = pcim_iomap_table(pdev)[0];
 


