Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0CQWGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:06:52 -0400
Received: from mail-ew0-f221.google.com ([209.85.219.221]:36574 "EHLO
	mail-ew0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0CQWGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:06:48 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 18:06:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gaGfxavo/iwuYfUfHXvr9tM9C9NOQxG7eb7py4xiqa4MBbwPD1j2domQAD26OloGvK
         cXCjg5FQR78CPLDtpqo2xh9XZAfOAJ/SG77+Bv5V8dPTmvtBvRropn77T0ObNpMyiJ63
         cFQ75TEFxT6NLoDiJzLqygpt+D8d+MXDy6gfs=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 4/9] USB: pl2303: increase the bulk-out buffer size to 256 byte
Date: Wed, 17 Mar 2010 23:00:40 +0100
Message-Id: <1268863245-17230-5-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
References: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the bulk-out buffer size from 64 to 256 byte.

This gives a significant increase in throughput already at 1Mbaud as well
as lowered CPU usage. The buffer is big enough to keep up also at 3Mbaud
(128b would not suffice).

        64b         256b
921k:   640 KB/s    870 KB/s
3M:     640 KB/s    2520 KB/s

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/pl2303.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 1891cfb..afa3744 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1168,6 +1168,7 @@ static struct usb_serial_driver pl2303_device = {
 	.id_table =		id_table,
 	.usb_driver = 		&pl2303_driver,
 	.num_ports =		1,
+	.bulk_out_size =	256,
 	.open =			pl2303_open,
 	.close =		pl2303_close,
 	.dtr_rts = 		pl2303_dtr_rts,
-- 
1.7.0.2

