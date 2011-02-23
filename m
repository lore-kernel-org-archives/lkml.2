Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1BWJYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:24:13 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53930 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1BWJYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:24:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=R4ZNeojqZdcsNaYJYFM6D9l3g3ssEYrs8n4oc6pryeo4GmsJm9vTp2++aI8WER5c6i
         xU+nGuulAYryusIeMX6WHg6UN6dZkmWKQttvFT+hDWZPkIikbw/w6ZWUDmub7rIVen7r
         h/bY5Qk3vxz7Ii64gIk7CRxiDhG0CgfNyH2UA=
Subject: [PATCH 1/2] rtc: rtc-mc13xxx: fix unterminated platform_device_id
	table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Content-Type: text/plain
Date: Wed, 23 Feb 2011 17:27:24 +0800
Message-Id: <1298453244.25444.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-mc13xxx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 5314b15..6e6de98 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -408,6 +408,7 @@ const struct platform_device_id mc13xxx_rtc_idtable[] = {
 	}, {
 		.name = "mc13892-rtc",
 	},
+	{ }
 };
 
 static struct platform_driver mc13xxx_rtc_driver = {
-- 
1.7.2



