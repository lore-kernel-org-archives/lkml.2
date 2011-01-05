Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1AEXLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:11:11 -0500
Received: from kroah.org ([198.145.64.141]:50744 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1AEXGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:22 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:24 2011
Message-Id: <20110105230324.742521835@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gabriele Gorla <gorlik@penguintown.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [13/49] hwmon: (adm1026) Allow 1 as a valid divider value
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Gabriele Gorla <gorlik@penguintown.net>

commit 8b0f1840a46449e1946fc88860ef3ec8d6b1c2c7 upstream.

Allow 1 as a valid div value as specified in the ADM1026 datasheet.

Signed-off-by: Gabriele Gorla <gorlik@penguintown.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/adm1026.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -923,9 +923,7 @@ static ssize_t set_fan_div(struct device
 
 	val = simple_strtol(buf, NULL, 10);
 	new_div = DIV_TO_REG(val);
-	if (new_div == 0) {
-		return -EINVAL;
-	}
+
 	mutex_lock(&data->update_lock);
 	orig_div = data->fan_div[nr];
 	data->fan_div[nr] = DIV_FROM_REG(new_div);


