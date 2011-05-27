Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1E0FbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:31:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2106 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1E0FbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:31:09 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/4] [media] DVB: Make struct dvb_usb_device_description members const
Date: Thu, 26 May 2011 22:30:59 -0700
Message-Id: <16244c98130505591a0b037fa3c997116d103fe7.1306473714.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.2.365.g5cfe4
In-Reply-To: <cover.1306473713.git.joe@perches.com>
References: <cover.1306473713.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct usb_device_id *s warm_ids and cold_ids are never modified.

Make the members const so the declarations of struct usb_device_id
can also be const.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 76a8096..a8761ad8 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -71,8 +71,8 @@ struct dvb_usb_device_description {
 	const char *name;
 
 #define DVB_USB_ID_MAX_NUM 15
-	struct usb_device_id *cold_ids[DVB_USB_ID_MAX_NUM];
-	struct usb_device_id *warm_ids[DVB_USB_ID_MAX_NUM];
+	const struct usb_device_id *cold_ids[DVB_USB_ID_MAX_NUM];
+	const struct usb_device_id *warm_ids[DVB_USB_ID_MAX_NUM];
 };
 
 static inline u8 rc5_custom(struct rc_map_table *key)
-- 
1.7.5.2.365.g5cfe4

