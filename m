Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab0HXWrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:47:46 -0400
Received: from kroah.org ([198.145.64.141]:59812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296Ab0HXWrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:47:43 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:18:20 2010
Message-Id: <20100824221820.752126412@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:17:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [8/8] USB: io_ti: check firmware version before updating
In-Reply-To: <20100824224631.GA5458@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1094
Lines: 32

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 0827a9ff2bbcbb03c33f1a6eb283fe051059482c upstream.

If we can't read the firmware for a device from the disk, and yet the
device already has a valid firmware image in it, we don't want to
replace the firmware with something invalid.  So check the version
number to be less than the current one to verify this is the correct
thing to do.


Reported-by: Chris Beauchamp <chris@chillibean.tv>
Tested-by: Chris Beauchamp <chris@chillibean.tv>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/io_ti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1156,7 +1156,7 @@ static int download_fw(struct edgeport_s
 
 			/* Check if we have an old version in the I2C and
 			   update if necessary */
-			if (download_cur_ver != download_new_ver) {
+			if (download_cur_ver < download_new_ver) {
 				dbg("%s - Update I2C dld from %d.%d to %d.%d",
 				    __func__,
 				    firmware_version->Ver_Major,


