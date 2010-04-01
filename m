Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0DALle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:41:34 -0400
Received: from mailgate02.web.de ([217.72.192.252]:48987 "EHLO
	mailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0DALl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:41:28 -0400
X-Greylist: delayed 1383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2010 07:41:28 EDT
Date: Thu, 1 Apr 2010 13:18:26 +0200 (CEST)
From: maxmax2010@web.de
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, w.sang@pengutronix.de, ryan@bluewatersys.com,
       hverkuil@xs4all.nl, cbouatmailru@gmail.com, khali@linux-fr.org
Message-ID: <9945954.711270120706653.JavaMail.fmail@mobilprefe03>
Subject: Aw: [PATCH] power/ds2782: fix clientdata on removal
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/I2P6gLQFVAadVH8z3aS14Esu8ZWPst8SakN5a+uxHIFH19kYcs98n
 bWA3alNukZ9xXYXy+sj2jJnj83r5d/xhQQ+urrr4vjjUOWVOL+R3K7h/+pdaxdYX
 5kFJLT5ng2Ms5cCK+Ry5pbczhEKdrHgFVvPfV/hUHa73+tGt9HF/LHsWVdxNKAkl
 0El6MPMbS+2v5ks2vA2/H91jPos3f/xxRULbmIVFoXzu0l+OJIzgKzd42dQVIOf2
 ZjbpUL0+L+vFLMwxMnh93yLs16MROfjyenjzKrPIzD4=
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
