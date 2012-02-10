Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab2BJWni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:43:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746Ab2BJWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:29 -0500
MIME-Version: 1.0
Message-Id: <20120210222952.530861507@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [patch 84/86] mmc: cb710 core: Add missing spin_lock_init for irq_lock of struct cb710_chip
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -245,6 +245,7 @@ static int __devinit cb710_probe(struct
 	if (err)
 		return err;
 
+	spin_lock_init(&chip->irq_lock);
 	chip->pdev = pdev;
 	chip->iobase = pcim_iomap_table(pdev)[0];
 


