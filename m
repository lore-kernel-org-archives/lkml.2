Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2EIFwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38630 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651Ab2EIFw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:29 -0400
Message-Id: <20120509055032.228633354@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 019/167] [PATCH] [media] rc-core: set mode for winbond-cir
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>

commit d9b786955f80fb306471fdb9ea24c6d03af6ca36 upstream.

Setting the correct mode is required by rc-core or scancodes won't be
generated (which isn't very user-friendly).

This one-line fix should be suitable for 3.4-rc2.

Signed-off-by: David Härdeman <david@hardeman.nu>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
-- 
1.7.10



