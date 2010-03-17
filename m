Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0CQWGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:06:22 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:42351 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab0CQWGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dZ0MJ9C7vqSRttkk72xwDp0kZfNFHFiWAHr6ZGQQ3Te885gvCVDf/r3WT/LPi6eSTA
         aCCAAgb/PZeUVeuOzTbyq7BjD7TbsDODnlQ0Bb9UHKLN6rK/VltMeJ2No5ff/5A9PWHx
         vgpJEqzugzVWYHH7ctW8HekY1VmqVFAHEB5hc=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 5/9] USB: pl2303: increase bulk-in buffer size to 256 byte
Date: Wed, 17 Mar 2010 23:00:41 +0100
Message-Id: <1268863245-17230-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
References: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pl2303 requires a bulk-in buffer larger than endpoint size to keep
up at high baudrates without loosing data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/pl2303.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index afa3744..84a7c1f 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1168,6 +1168,7 @@ static struct usb_serial_driver pl2303_device = {
 	.id_table =		id_table,
 	.usb_driver = 		&pl2303_driver,
 	.num_ports =		1,
+	.bulk_in_size =		256,
 	.bulk_out_size =	256,
 	.open =			pl2303_open,
 	.close =		pl2303_close,
-- 
1.7.0.2

