Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966440Ab0CPOyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:54:12 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:34226 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966425Ab0CPOyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:54:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Alan Nisota <alannisota@gmail.com>, Patrick Boettcher <pb@linuxtv.org>
Subject: [PATCH 1/1] DVB-USB: gp8psk, fix potential null derefernce
Date: Tue, 16 Mar 2010 15:51:26 +0100
Message-Id: <1268751086-14003-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that in gp8psk_load_bcm4500fw there is missing a check for
return value of kmalloc. Add one and bail out appropriatelly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Nisota <alannisota@gmail.com>
Cc: Patrick Boettcher <pb@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/dvb/dvb-usb/gp8psk.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index afb444d..45106ac 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -105,6 +105,10 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 
 	ptr = fw->data;
 	buf = kmalloc(64, GFP_KERNEL | GFP_DMA);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out_rel_fw;
+	}
 
 	while (ptr[0] != 0xff) {
 		u16 buflen = ptr[0] + 4;
-- 
1.7.0.1


