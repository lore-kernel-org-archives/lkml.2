Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0CQWGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:06:13 -0400
Received: from mail-ew0-f221.google.com ([209.85.219.221]:36574 "EHLO
	mail-ew0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab0CQWGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:06:10 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 18:06:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YjFHASNQ8LjU3JoWmvWA2/OpvX9PvxwnVZUCPwpNHsCIrmOx/U1NhiFzdtXD/n46Yz
         6qQYNYH6ReOPQdWaPkEOZ3vq5Egz9SFrV1MQw7JAeswcTC/4H7XejkWve0YXa7JjgsFE
         Ck1inc3gKRnx2yL905KsNsAVCkbnmU+2Jw980=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3/9] USB: cp210x: increase bulk-in buffer size to 256 byte
Date: Wed, 17 Mar 2010 23:00:39 +0100
Message-Id: <1268863245-17230-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
References: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cp210x requires a bulk-in buffer larger than endpoint size to keep
up at high baudrates without loosing data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index e344000..705a7e7 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -138,6 +138,7 @@ static struct usb_serial_driver cp210x_device = {
 	.usb_driver		= &cp210x_driver,
 	.id_table		= id_table,
 	.num_ports		= 1,
+	.bulk_in_size		= 256,
 	.bulk_out_size		= 256,
 	.open			= cp210x_open,
 	.close			= cp210x_close,
-- 
1.7.0.2

