Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab1DYUrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:47:08 -0400
Received: from 1wt.eu ([62.212.114.60]:34250 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025Ab1DYUYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:40 -0400
Message-Id: <20110425200236.428096148@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 079/173] hwmon/f71882fg: Set platform drvdata to NULL later
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit d9ebaa45472c92704f4814682eec21455edcfa1f upstream.

This avoids a possible race leading to trying to dereference NULL.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/f71882fg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: longterm-2.6.27/drivers/hwmon/f71882fg.c
===================================================================
--- longterm-2.6.27.orig/drivers/hwmon/f71882fg.c	2011-01-23 10:52:16.000000000 +0100
+++ longterm-2.6.27/drivers/hwmon/f71882fg.c	2011-04-25 15:34:40.461278503 +0200
@@ -808,7 +808,6 @@
 	int i;
 	struct f71882fg_data *data = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	hwmon_device_unregister(data->hwmon_dev);
 
 	for (i = 0; i < ARRAY_SIZE(f71882fg_dev_attr); i++)
@@ -821,6 +820,7 @@
 	for (i = 0; i < ARRAY_SIZE(f71882fg_fan_attr); i++)
 		device_remove_file(&pdev->dev, &f71882fg_fan_attr[i].dev_attr);
 
+	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 
 	return 0;


