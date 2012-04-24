Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab2DXWht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:37:49 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776Ab2DXWhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:46 -0400
Message-Id: <20120424223254.590419770@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 13/42] media: rc-core: set mode for winbond-cir
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Härdeman <david@hardeman.nu>

commit d9b786955f80fb306471fdb9ea24c6d03af6ca36 upstream.

Setting the correct mode is required by rc-core or scancodes won't be
generated (which isn't very user-friendly).

This one-line fix should be suitable for 3.4-rc2.

Signed-off-by: David Härdeman <david@hardeman.nu>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/winbond-cir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1058,6 +1058,7 @@ wbcir_probe(struct pnp_dev *device, cons
 		goto exit_unregister_led;
 	}
 
+	data->dev->driver_type = RC_DRIVER_IR_RAW;
 	data->dev->driver_name = WBCIR_NAME;
 	data->dev->input_name = WBCIR_NAME;
 	data->dev->input_phys = "wbcir/cir0";


