Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2HSRep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:34:45 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:38364 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2HSRek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:34:40 -0400
Date: Sun, 19 Aug 2012 19:33:56 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] HID: picoLCD: use proper device as input_dev parent
Message-ID: <20120819193356.3f853c78@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120819192859.74136bb0@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 580269b..86df26e 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -446,7 +446,7 @@ static int picolcd_init_keys(struct picolcd_data *data,
 	idev->id.vendor  = hdev->vendor;
 	idev->id.product = hdev->product;
 	idev->id.version = hdev->version;
-	idev->dev.parent = hdev->dev.parent;
+	idev->dev.parent = &hdev->dev;
 	idev->keycode     = &data->keycode;
 	idev->keycodemax  = PICOLCD_KEYS;
 	idev->keycodesize = sizeof(data->keycode[0]);
-- 
1.7.8.6

