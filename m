Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1EKQme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:42:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63973 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab1EKQmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=m1ejlidRIxBnPlyc2kKLzCgmo0GEusUvNBgERjrDd9tXr7uQZz7OhVz4c7hpl61mnq
         Bi+g+6HSfYoRkNRor6lKINQAYOS09DZuHL+HcTvz+r94VgLWjhJ5qF9086wQ1qRvMa9U
         6oft10f23oBZ+gaNfLUhqEc1nB7l6XxU2/SbM=
Subject: [PATCH] spi: tle620x: add missing device_remove_file()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben@simtec.co.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 20:39:05 +0800
Message-ID: <1305117545.6324.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. Add missing device_remove_file for dev_attr_status_show in tle62x0_remove.
2. Fix tle62x0_probe error handling:
   Currently, if the error happens when ptr > 0, gpio_attrs[0] is not
   properly remove.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/spi/tle62x0.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/tle62x0.c b/drivers/spi/tle62x0.c
index a393895..32a4087 100644
--- a/drivers/spi/tle62x0.c
+++ b/drivers/spi/tle62x0.c
@@ -283,7 +283,7 @@ static int __devinit tle62x0_probe(struct spi_device *spi)
 	return 0;
 
  err_gpios:
-	for (; ptr > 0; ptr--)
+	while (--ptr >= 0)
 		device_remove_file(&spi->dev, gpio_attrs[ptr]);
 
 	device_remove_file(&spi->dev, &dev_attr_status_show);
@@ -301,6 +301,7 @@ static int __devexit tle62x0_remove(struct spi_device *spi)
 	for (ptr = 0; ptr < st->nr_gpio; ptr++)
 		device_remove_file(&spi->dev, gpio_attrs[ptr]);
 
+	device_remove_file(&spi->dev, &dev_attr_status_show);
 	kfree(st);
 	return 0;
 }
-- 
1.7.1



