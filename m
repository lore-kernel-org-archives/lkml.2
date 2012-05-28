Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2E1DnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:43:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52119 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985Ab2E1D3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:35 -0400
Message-Id: <20120528031215.714957298@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 093/117] b43legacy: Fix error due to MMIO access with SSB unpowered
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 8f4b20388fa77226a3605627a33a23f90d559e50 upstream.

There is a dummy read of a PCI MMIO register that occurs before the SSB bus
has been powered, which is an error. This bug has not been seen earlier,
but was apparently exposed when udev was updated to version 182.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/b43legacy/main.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 1be214b..1deafaa 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1573,8 +1573,6 @@ static void b43legacy_request_firmware(struct work_struct *work)
 	const char *filename;
 	int err;
 
-	/* do dummy read */
-	ssb_read32(dev->dev, SSB_TMSHIGH);
 	if (!fw->ucode) {
 		if (rev == 2)
 			filename = "ucode2";


