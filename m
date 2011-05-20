Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935432Ab1ETSej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:34:39 -0400
Received: from nm12.bullet.mail.ird.yahoo.com ([77.238.189.65]:29221 "HELO
	nm12.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934869Ab1ETSeh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:34:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 360224.35625.bm@omp1005.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=k1UzuWU5ny79ZX4WC/bB4ePuuWpGZVCnUsHCTS/MO6lZnPfivQztMFhQV4RGbVTd9DV7SjasF4wU1171BkBs8aI3NA53aZ5nwbm/aLWCY53n3KGQtKlVxgi4dq4eBQd2C3pEVdVZb9IXqYT25uY/QtW9c8iKCkD5Bt1TO3aFbHc=;
Message-ID: <931974.15363.qm@web29013.mail.ird.yahoo.com>
X-YMail-OSG: aJhC5a4VM1lOgNauHUjQiEiKBW5ukXOsZ6nZoKrsc7Ook57
 .lVMNY8TGkig8ok_mi8LuKJAOFllNOpBBp5JSLrxN5QTFPUXHKdKqpTamzrj
 gSskxaUa1V4wYyUqR_3z4mexAyRae1uB5lyLsuDkUKd.2Qkv_LgHUOIGPQuU
 ROEjg4NUfjcjPN9HAQYpa9LITnM9lgHKhXufTHlqHiwMrdeW03kFb1b9VdDp
 ZBRywWq..Xy0c1Qih_fu3RJCOefGt2djf6qwt6p90Vfp1Vao3KFm8tveJPvm
 t4QnBvkfXySSCwP1bp9vAt3RqqNFmmYVmUr9CGrXEmoQTB_leDHAfV.sucQ-
 -
X-Mailer: YahooMailClassic/14.0.1 YahooMailWebService/0.8.111.303096
Date: Fri, 20 May 2011 19:34:32 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH] ds2760_battery: Fix rated capacity of the hx4700 1800mAh battery
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <20110520174546.GA27734@rainbow>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW, hx4700 also have extended batteries. I personally have
> one that rated
> 3600mAh with my hx4700. Sadly I dropped it on the floor
> some time ago and
> battery lock got broken, so I currently can't use it. But I
> hope to fix it
> some day.

I knew about the 3600mAh battery but unfortunately I don't possess one, so was not able to add it to the patch. I only have the default 1800mAh battery which shipped with the hx4700.

If anybody here does have an hx4700 with the 3600mAh battery and is able to run Linux on it, it would be a big help if they could apply the following patch to discover the rated capacity register value via dmesg:

--- clean-2.6.39/drivers/power/ds2760_battery.c	2011-05-19 05:06:34.000000000 +0100
+++ linux-2.6.39/drivers/power/ds2760_battery.c	2011-05-20 19:20:11.533136179 +0100
@@ -136,6 +136,9 @@ static int ds2760_battery_read_status(st
 		return 1;
 	}
 
+	if (di->update_time == 0)
+		printk("%s: rated capacity = %d\n", __func__, di->raw[DS2760_RATED_CAPACITY]);
+
 	di->update_time = jiffies;
 
 	/* DS2760 reports voltage in units of 4.88mV, but the battery class

Or perhaps HaRET has some means of dumping the register?
