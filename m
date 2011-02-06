Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1BFXsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:48:31 -0500
Received: from 1wt.eu ([62.212.114.60]:60344 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1BFXs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:48:29 -0500
Message-Id: <20110206232252.831383919@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:22:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Gabriele Gorla <gorlik@penguintown.net>, Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 07/23] hwmon: (adm1026) Allow 1 as a valid divider value
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gabriele Gorla <gorlik@penguintown.net>

commit 8b0f1840a46449e1946fc88860ef3ec8d6b1c2c7 upstream.

Allow 1 as a valid div value as specified in the ADM1026 datasheet.

Signed-off-by: Gabriele Gorla <gorlik@penguintown.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 drivers/hwmon/adm1026.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: longterm-2.6.27/drivers/hwmon/adm1026.c
===================================================================
--- longterm-2.6.27.orig/drivers/hwmon/adm1026.c	2011-01-29 11:19:14.685064867 +0100
+++ longterm-2.6.27/drivers/hwmon/adm1026.c	2011-01-29 11:27:12.646064622 +0100
@@ -926,9 +926,7 @@
 
 	val = simple_strtol(buf, NULL, 10);
 	new_div = DIV_TO_REG(val);
-	if (new_div == 0) {
-		return -EINVAL;
-	}
+
 	mutex_lock(&data->update_lock);
 	orig_div = data->fan_div[nr];
 	data->fan_div[nr] = DIV_FROM_REG(new_div);


