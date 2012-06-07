Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab2FGESz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:18:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab2FGESt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:49 -0400
Message-Id: <20120607040342.849554995@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:21 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gabor Juhos <juhosg@openwrt.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 45/82] mtd: block2mtd: fix recursive call of mtd_writev
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit 2e24e32e2759348c9290404abad4f729f791bfad upstream.

The 'mtd_writev' interface calls the function assigned
to the '_write' field of a given mtd device if that is
not NULL. The block2mtd driver sets the '_writev' field
to the 'mtd_writev' function itself and thus causes a
endless loop.

This is caused by 1dbebd32562b3c2caeca35960e5cb00bfcc12900
(mtd: harmonize mtd_writev usage).

Remove the assignment from the block2mtd driver to fix the
issue.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/block2mtd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -271,7 +271,6 @@ static struct block2mtd_dev *add_device(
 	dev->mtd.flags = MTD_CAP_RAM;
 	dev->mtd._erase = block2mtd_erase;
 	dev->mtd._write = block2mtd_write;
-	dev->mtd._writev = mtd_writev;
 	dev->mtd._sync = block2mtd_sync;
 	dev->mtd._read = block2mtd_read;
 	dev->mtd.priv = dev;


