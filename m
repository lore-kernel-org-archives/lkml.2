Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934721Ab2C3UHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:07:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53485 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934637Ab2C3UFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:05:41 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Subject: [PATCH v2 05/15] hwmon: mark const init data with __initconst instead of __initdata
Date: Fri, 30 Mar 2012 22:04:55 +0200
Message-Id: <1333137905-13809-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120330200358.GV15647@pengutronix.de>
References: <20120330200358.GV15647@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org
---
changes since (implicit) v1:
 - drop wrong changes to drivers/hwmon/w83627hf.c

 drivers/hwmon/w83627ehf.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index a25350c..54922ed 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -2619,15 +2619,15 @@ static struct platform_driver w83627ehf_driver = {
 static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 				 struct w83627ehf_sio_data *sio_data)
 {
-	static const char __initdata sio_name_W83627EHF[] = "W83627EHF";
-	static const char __initdata sio_name_W83627EHG[] = "W83627EHG";
-	static const char __initdata sio_name_W83627DHG[] = "W83627DHG";
-	static const char __initdata sio_name_W83627DHG_P[] = "W83627DHG-P";
-	static const char __initdata sio_name_W83627UHG[] = "W83627UHG";
-	static const char __initdata sio_name_W83667HG[] = "W83667HG";
-	static const char __initdata sio_name_W83667HG_B[] = "W83667HG-B";
-	static const char __initdata sio_name_NCT6775[] = "NCT6775F";
-	static const char __initdata sio_name_NCT6776[] = "NCT6776F";
+	static const char sio_name_W83627EHF[] __initconst = "W83627EHF";
+	static const char sio_name_W83627EHG[] __initconst = "W83627EHG";
+	static const char sio_name_W83627DHG[] __initconst = "W83627DHG";
+	static const char sio_name_W83627DHG_P[] __initconst = "W83627DHG-P";
+	static const char sio_name_W83627UHG[] __initconst = "W83627UHG";
+	static const char sio_name_W83667HG[] __initconst = "W83667HG";
+	static const char sio_name_W83667HG_B[] __initconst = "W83667HG-B";
+	static const char sio_name_NCT6775[] __initconst = "NCT6775F";
+	static const char sio_name_NCT6776[] __initconst = "NCT6776F";
 
 	u16 val;
 	const char *sio_name;
-- 
1.7.9.5

