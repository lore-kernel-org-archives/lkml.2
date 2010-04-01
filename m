Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0DALrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:47:15 -0400
Received: from mailgate01.web.de ([217.72.192.251]:47568 "EHLO
	mailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab0DALrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:47:09 -0400
Date: Thu, 1 Apr 2010 13:18:24 +0200 (CEST)
From: maxmax2010@web.de
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, w.sang@pengutronix.de, ryan@bluewatersys.com,
       hverkuil@xs4all.nl, cbouatmailru@gmail.com, khali@linux-fr.org
Message-ID: <1837266.561270120704376.JavaMail.fmail@mobilprefe03>
Subject: Aw: [PATCH] power/ds2782: fix clientdata on removal
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19TlqNIAq/oLqAiLGQ4wcnmXMNdffjJDzQ4mEizpM2CmnfpUZEj4PC3
 0zmGouqum1R5c5+H7bWK4YoCqEvBq1b0EmpNjYjiApExsuPNwokatxsettPSIIAN
 SiAzM1FfpQ+ijz6kponABbqWeylXcD8BGlYgSht9hwO4d9f5NfIVp8BlinCxziRr
 q6i/VPw1z49xvtvFTNWL50EV7Skuiv4Sv43piwV2LVLfvxPj9/G/S45Ur5i+wYFV
 22x9rLTE4wN3Pk60g+lvg/Dmcvpp6QOVAvE1GKw3UHk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testamtwort


-----Ursprüngliche Nachricht-----
Von: maxmax2010@web.de
Gesendet: 01.04.2010 12:27:44
An: linux-i2c@vger.kernel.org
Betreff: [PATCH] power/ds2782: fix clientdata on removal

>Probably due to a copy & paste bug, clientdata was set again to the data
>structure (which is freed immediately afterwards) when it should be
>NULLed. Just remove the calls as the i2c-core does this automatically
>now.
>
>Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
>Cc: Ryan Mallon <ryan@bluewatersys.com>
>Cc: Hans Verkuil <hverkuil@xs4all.nl>
>Cc: Anton Vorontsov <cbouatmailru@gmail.com>
>Cc: Jean Delvare <khali@linux-fr.org>
>---
>
>Anton: If it is okay with you, I think this should go via the I2C-tree to
>ensure it comes after the needed modification of the i2c-core.
>
> drivers/power/ds2782_battery.c |    3 ---
> 1 files changed, 0 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
>index da14f37..305d463 100644
>--- a/drivers/power/ds2782_battery.c
>+++ b/drivers/power/ds2782_battery.c
>@@ -236,8 +236,6 @@ static int ds2782_battery_remove(struct i2c_client *client)
> 	idr_remove(&battery_id, info->id);
> 	mutex_unlock(&battery_lock);
> 
>-	i2c_set_clientdata(client, info);
>-
> 	kfree(info);
> 	return 0;
> }
>@@ -289,7 +287,6 @@ static int ds2782_battery_probe(struct i2c_client *client,
> fail_register:
> 	kfree(info->battery.name);
> fail_name:
>-	i2c_set_clientdata(client, info);
> 	kfree(info);
> fail_info:
> 	mutex_lock(&battery_lock);
>-- 
>1.7.0
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
