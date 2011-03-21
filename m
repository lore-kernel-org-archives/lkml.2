Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1CUXPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:03 -0400
Received: from kroah.org ([198.145.64.141]:49189 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab1CUXO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:14:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:09 2011
Message-Id: <20110321230709.257505289@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [01/87] hwmon/f71882fg: Set platform drvdata to NULL later
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -2110,7 +2110,6 @@ static int f71882fg_remove(struct platfo
 	int nr_fans = (data->type == f71882fg) ? 4 : 3;
 	u8 start_reg = f71882fg_read8(data, F71882FG_REG_START);
 
-	platform_set_drvdata(pdev, NULL);
 	if (data->hwmon_dev)
 		hwmon_device_unregister(data->hwmon_dev);
 
@@ -2177,6 +2176,7 @@ static int f71882fg_remove(struct platfo
 		}
 	}
 
+	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 
 	return 0;


