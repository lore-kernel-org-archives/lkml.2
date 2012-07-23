Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2GWBtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:49:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54433 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753561Ab2GWBni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:38 -0400
Message-Id: <20120723010658.134773192@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
        Stevie Trujillo <stevie.trujillo@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 044/108] hwmon: (it87) Preserve configuration register bits on init
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 41002f8dd5938d5ad1d008ce5bfdbfe47fa7b4e8 upstream.

We were accidentally losing one bit in the configuration register on
device initialization. It was reported to freeze one specific system
right away. Properly preserve all bits we don't explicitly want to
change in order to prevent that.

Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/it87.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index e7701d9..f1de397 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -2341,7 +2341,7 @@ static void __devinit it87_init_device(struct platform_device *pdev)
 
 	/* Start monitoring */
 	it87_write_value(data, IT87_REG_CONFIG,
-			 (it87_read_value(data, IT87_REG_CONFIG) & 0x36)
+			 (it87_read_value(data, IT87_REG_CONFIG) & 0x3e)
 			 | (update_vbat ? 0x41 : 0x01));
 }
 


