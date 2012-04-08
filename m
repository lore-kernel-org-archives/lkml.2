Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab2DHKYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 06:24:15 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:55084 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2DHKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 06:24:14 -0400
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2012 06:24:14 EDT
Subject: [PATCH] rc-core: set mode for winbond-cir
To: torvalds@linux-foundation.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Date: Sun, 08 Apr 2012 12:13:04 +0200
Message-ID: <20120408101304.9258.48076.stgit@felix.hardeman.nu>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the correct mode is required by rc-core or scancodes won't be
generated (which isn't very user-friendly).

This one-line fix should be suitable for 3.4-rc2.

Signed-off-by: David Härdeman <david@hardeman.nu>
Cc: stable@kernel.org
---
 drivers/media/rc/winbond-cir.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index b09c5fa..af52658 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1046,6 +1046,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 		goto exit_unregister_led;
 	}
 
+	data->dev->driver_type = RC_DRIVER_IR_RAW;
 	data->dev->driver_name = WBCIR_NAME;
 	data->dev->input_name = WBCIR_NAME;
 	data->dev->input_phys = "wbcir/cir0";

