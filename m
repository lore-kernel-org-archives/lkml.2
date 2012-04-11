Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab2DKXWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:22:08 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51108 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933880Ab2DKXWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:22:05 -0400
Message-Id: <20120411231037.825666309@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 14/59] mtd: m25p80: set writebufsize
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <computersforpeace@gmail.com>

commit b54f47c8bcfc5f766bf13ec31bd7dd1d4726d33b upstream.

Using UBI on m25p80 can give messages like:

    UBI error: io_init: bad write buffer size 0 for 1 min. I/O unit

We need to initialize writebufsize; I think "page_size" is the correct
"bufsize", although I'm not sure. Comments?

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/m25p80.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -932,6 +932,7 @@ static int __devinit m25p_probe(struct s
 	ppdata.of_node = spi->dev.of_node;
 	flash->mtd.dev.parent = &spi->dev;
 	flash->page_size = info->page_size;
+	flash->mtd.writebufsize = flash->page_size;
 
 	if (info->addr_width)
 		flash->addr_width = info->addr_width;


