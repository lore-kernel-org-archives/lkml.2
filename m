Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2IQAu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33369 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017Ab2IQAte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:34 -0400
Message-Id: <20120917003627.763652634@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Luca Tettamanti <kronos.it@gmail.com>,
        =?ISO-8859-15?q?G=C3=B6ran=20Uddeborg?= <goeran@uddeborg.se>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 011/135] hwmon: (asus_atk0110) Add quirk for Asus M5A78L
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Tettamanti <kronos.it@gmail.com>

commit 43ca6cb28c871f2fbad10117b0648e5ae3b0f638 upstream.

The old interface is bugged and reads the wrong sensor when retrieving
the reading for the chassis fan (it reads the CPU sensor); the new
interface works fine.

Reported-by: Göran Uddeborg <goeran@uddeborg.se>
Tested-by: Göran Uddeborg <goeran@uddeborg.se>
Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/asus_atk0110.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index 351d1f4..4ee5789 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -34,6 +34,12 @@ static const struct dmi_system_id __initconst atk_force_new_if[] = {
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "SABERTOOTH X58")
 		}
+	}, {
+		/* Old interface reads the same sensor for fan0 and fan1 */
+		.ident = "Asus M5A78L",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "M5A78L")
+		}
 	},
 	{ }
 };


