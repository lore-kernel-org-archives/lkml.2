Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab1EXVTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:19:37 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:34956 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1EXVTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:19:36 -0400
Message-ID: <4DDC20D6.9050102@freemail.hu>
Date: Tue, 24 May 2011 23:19:18 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        "(commit_signer:4/10=40%) Endre Kollar" <taxy443@gmail.com>,
        Arjan Mels <arjan.mels@gmx.net>, Max Vozeler <max@vozeler.com>
CC: devel@driverdev.osuosl.org, usbip-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usbip: simplify lock handling in valid_request()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.98.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The function calls spin_lock() and spin_unlock() should be in pair. This patch makes
this pairing more clear for the reader of the code.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index a5c1fa1..e2cfedb 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -304,18 +304,18 @@ static int stub_recv_cmd_unlink(struct stub_device *sdev,
 static int valid_request(struct stub_device *sdev, struct usbip_header *pdu)
 {
 	struct usbip_device *ud = &sdev->ud;
+	int valid = 0;

 	if (pdu->base.devid == sdev->devid) {
 		spin_lock(&ud->lock);
 		if (ud->status == SDEV_ST_USED) {
 			/* A request is valid. */
-			spin_unlock(&ud->lock);
-			return 1;
+			valid = 1;
 		}
 		spin_unlock(&ud->lock);
 	}

-	return 0;
+	return valid;
 }

 static struct stub_priv *stub_priv_alloc(struct stub_device *sdev,
