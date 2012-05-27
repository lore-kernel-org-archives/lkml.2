Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2E0BZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:25:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2E0BT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:19:28 -0400
Message-Id: <20120527002521.093852080@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:11 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 65/91] b43legacy: Fix error due to MMIO access with SSB unpowered
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 8f4b20388fa77226a3605627a33a23f90d559e50 upstream.

There is a dummy read of a PCI MMIO register that occurs before the SSB bus
has been powered, which is an error. This bug has not been seen earlier,
but was apparently exposed when udev was updated to version 182.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/b43legacy/main.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1571,8 +1571,6 @@ static void b43legacy_request_firmware(s
 	const char *filename;
 	int err;
 
-	/* do dummy read */
-	ssb_read32(dev->dev, SSB_TMSHIGH);
 	if (!fw->ucode) {
 		if (rev == 2)
 			filename = "ucode2";


