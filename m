Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0CQWIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:08:51 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:6552 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0CQWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=R/rlmIygSY56myDLrc8Zw3P43mD30ZGgZ9AnxGxP7pHh17GdNawcWthTrgDh+T2O67
         BizZqg8+cnLe2bMxwx4bSc5hYl/9pnoylmL/pzk6TYXLWpNJV720Is6puJH3cnK1qhPe
         o0j+h+fv9/OUlR8sn6ZY3mcIxM4/3uo94M55s=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/9] USB: cp210x: increase the bulk-out buffer size to 256 byte
Date: Wed, 17 Mar 2010 23:00:38 +0100
Message-Id: <1268863245-17230-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
References: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the bulk-out buffer size from 64 to 256 byte.

This gives a significant increase in throughput already at 1Mbaud
(e.g. 710 instead of 640 KB/s) as well as lowered CPU usage.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index ec9b044..e344000 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -138,6 +138,7 @@ static struct usb_serial_driver cp210x_device = {
 	.usb_driver		= &cp210x_driver,
 	.id_table		= id_table,
 	.num_ports		= 1,
+	.bulk_out_size		= 256,
 	.open			= cp210x_open,
 	.close			= cp210x_close,
 	.break_ctl		= cp210x_break_ctl,
-- 
1.7.0.2

