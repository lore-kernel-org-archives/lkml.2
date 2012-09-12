Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2ILX5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:57:36 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab2ILXmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:42:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?q?G=C3=B6ran=20Uddeborg?= <goeran@uddeborg.se>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: =?UTF-8?q?=5B=2085/85=5D=20hwmon=3A=20=28asus=5Fatk0110=29=20Add=20quirk=20for=20Asus=20M5A78L?=
Date: Wed, 12 Sep 2012 16:37:08 -0700
Message-Id: <20120912233550.569736985@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/asus_atk0110.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -34,6 +34,12 @@ static const struct dmi_system_id __init
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


