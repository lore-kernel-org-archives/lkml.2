Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab2DKXPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:15:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933676Ab2DKXPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:15:25 -0400
Message-Id: <20120411231020.397585272@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 13/78] mtd: sst25l: initialize writebufsize
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit c4cc625ea5958d065c21cc0fcea29e9ed8f3d2bc upstream.

The writebufsize concept was introduce by commit
"0e4ca7e mtd: add writebufsize field to mtd_info struct" and it represents
the maximum amount of data the device writes to the media at a time. This is
an important parameter for UBIFS which is used during recovery and which
basically defines how big a corruption caused by a power cut can be.

Set writebufsize to the flash page size because it is the maximum amount of
data it writes at a time.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/sst25l.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -402,6 +402,7 @@ static int __devinit sst25l_probe(struct
 	flash->mtd.flags	= MTD_CAP_NORFLASH;
 	flash->mtd.erasesize	= flash_info->erase_size;
 	flash->mtd.writesize	= flash_info->page_size;
+	flash->mtd.writebufsize	= flash_info->page_size;
 	flash->mtd.size		= flash_info->page_size * flash_info->nr_pages;
 	flash->mtd.erase	= sst25l_erase;
 	flash->mtd.read		= sst25l_read;


