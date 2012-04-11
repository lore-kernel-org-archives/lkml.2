Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524Ab2DKXjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:39:36 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53150 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965508Ab2DKX1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:27:50 -0400
Message-Id: <20120411231308.217681232@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Joern Engel <joern@lazybastard.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 05/42] mtd: block2mtd: initialize writebufsize
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit b604387411ec6a072e95910099262616edd2bd2f upstream.

The writebufsize concept was introduce by commit
"0e4ca7e mtd: add writebufsize field to mtd_info struct" and it represents
the maximum amount of data the device writes to the media at a time. This is
an important parameter for UBIFS which is used during recovery and which
basically defines how big a corruption caused by a power cut can be.

However, we forgot to set this parameter for block2mtd. Set it to PAGE_SIZE
because this is actually the amount of data we write at a time.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Acked-by: Joern Engel <joern@lazybastard.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/block2mtd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -284,6 +284,7 @@ static struct block2mtd_dev *add_device(
 	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
 	dev->mtd.erasesize = erase_size;
 	dev->mtd.writesize = 1;
+	dev->mtd.writebufsize = PAGE_SIZE;
 	dev->mtd.type = MTD_RAM;
 	dev->mtd.flags = MTD_CAP_RAM;
 	dev->mtd.erase = block2mtd_erase;


