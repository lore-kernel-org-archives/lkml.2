Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1AXOXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:23:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35329 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab1AXOXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:23:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hmhiOT+Uz8uEiHe7TJTG2w8FoGdul0DLWa/xtV2vaDg4l0J8WXBm8HIehZr1d1nzdE
         NAZZ3PX9j9TghBSXx0Z4Gf4V35Cah+P29c+6uKTZE1d2acR0OEHr5lgYm/oJxRHUu9Cs
         xQiB1fAGtH5V/ErGFdSpe8Mk5Q9dZgVOo6IZQ=
Date: Mon, 24 Jan 2011 15:23:15 +0100
From: Tejun Heo <tj@kernel.org>
To: Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] radio-wl1273: remove unused wl1273_device->work
Message-ID: <20110124142315.GE11404@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wl1273_device->work is unused.  Remove it along with the spurious
flush_scheduled_work() call in wl1273_fm_module_exit().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/radio/radio-wl1273.c |    5 -----
 1 file changed, 5 deletions(-)

Index: work/drivers/media/radio/radio-wl1273.c
===================================================================
--- work.orig/drivers/media/radio/radio-wl1273.c
+++ work/drivers/media/radio/radio-wl1273.c
@@ -67,7 +67,6 @@ struct wl1273_device {
 
 	/* RDS */
 	unsigned int rds_on;
-	struct delayed_work work;
 
 	wait_queue_head_t read_queue;
 	struct mutex lock; /* for serializing fm radio operations */
@@ -1112,9 +1111,6 @@ static int wl1273_fm_rds_off(struct wl12
 	if (r)
 		goto out;
 
-	/* stop rds reception */
-	cancel_delayed_work(&radio->work);
-
 	/* Service pending read */
 	wake_up_interruptible(&radio->read_queue);
 
@@ -2319,7 +2315,6 @@ module_init(wl1273_fm_module_init);
 
 static void __exit wl1273_fm_module_exit(void)
 {
-	flush_scheduled_work();
 	platform_driver_unregister(&wl1273_fm_radio_driver);
 	pr_info(DRIVER_DESC ", Exiting.\n");
 }
