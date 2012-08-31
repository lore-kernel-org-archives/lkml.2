Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2HaJZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:25:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44544 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2HaJZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:25:30 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/22] lp8727_charger: clean up lp8727_is_charger_attached()
Thread-Topic: [PATCH 12/22] lp8727_charger: clean up
 lp8727_is_charger_attached()
Thread-Index: Ac2HWojWO3d4q5qPQOKQ57PWnYRa5g==
Date: Fri, 31 Aug 2012 09:25:22 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F04@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: DEIG DXo7 E5zW GpJF I5G0 KpPc Lwqe UAPg U2VN XEPZ Yf4O
 Zb84 cXgS eMN8 emv/
 eolJ;3;YQBuAHQAbwBuAC4AdgBvAHIAbwBuAHQAcwBvAHYAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAZAB3AG0AdwAyAEAAaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{6E6A8A23-477C-4128-9DB2-0F6BF4FDBAE3};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Fri,
 31 Aug 2012 09:25:17
 GMT;WwBQAEEAVABDAEgAIAAxADIALwAyADIAXQAgAGwAcAA4ADcAMgA3AF8AYwBoAGEAcgBnAGUAcgA6ACAAYwBsAGUAYQBuACAAdQBwACAAbABwADgANwAyADcAXwBpAHMAXwBjAGgAYQByAGcAZQByAF8AYQB0AHQAYQBjAGgAZQBkACgAKQA=
x-cr-puzzleid: {6E6A8A23-477C-4128-9DB2-0F6BF4FDBAE3}
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Change return type as boolean.
 Remove unnecessary check routine for NULL string.
 (Power supply name is always valid when the function is executed.)

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 254bbe0..658518b 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -124,16 +124,14 @@ static int lp8727_write_byte(struct lp8727_chg *pchg, u8 reg, u8 data)
 	return ret;
 }
 
-static int lp8727_is_charger_attached(const char *name, int id)
+static bool lp8727_is_charger_attached(const char *name, int id)
 {
-	if (name) {
-		if (!strcmp(name, "ac"))
-			return (id == LP8727_ID_TA || id == LP8727_ID_DEDICATED_CHG) ? 1 : 0;
-		else if (!strcmp(name, "usb"))
-			return (id == LP8727_ID_USB_CHG) ? 1 : 0;
-	}
+	if (!strcmp(name, "ac"))
+		return id == LP8727_ID_TA || id == LP8727_ID_DEDICATED_CHG;
+	else if (!strcmp(name, "usb"))
+		return id == LP8727_ID_USB_CHG;
 
-	return (id >= LP8727_ID_TA && id <= LP8727_ID_USB_CHG) ? 1 : 0;
+	return id >= LP8727_ID_TA && id <= LP8727_ID_USB_CHG;
 }
 
 static int lp8727_init_device(struct lp8727_chg *pchg)
-- 
1.7.9.5


Best Regards,
Milo


