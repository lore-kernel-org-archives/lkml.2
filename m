Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2BAVlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:41:45 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52224 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757152Ab2BAVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:29 -0500
X-Sasl-enc: 63QpNBz6QdeYI1pwSsBoBydbH3x5qkygbUf718nNnKZI 1328130567
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:41 2012
Message-Id: <20120201205741.222803315@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [43/65] hwmon: (f71805f) Fix clamping of temperature limits
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 86b2bbfdbd1fcc4a3aa62ccd3f245c40c5ad5b85 upstream.

Properly clamp temperature limits set by the user. Without this fix,
attempts to write temperature limits above the maximum supported by
the chip (255 degrees Celsius) would arbitrarily and unexpectedly
result in the limit being set to 0 degree Celsius.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/f71805f.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -283,11 +283,11 @@ static inline long temp_from_reg(u8 reg)
 
 static inline u8 temp_to_reg(long val)
 {
-	if (val < 0)
-		val = 0;
-	else if (val > 1000 * 0xff)
-		val = 0xff;
-	return ((val + 500) / 1000);
+	if (val <= 0)
+		return 0;
+	if (val >= 1000 * 0xff)
+		return 0xff;
+	return (val + 500) / 1000;
 }
 
 /*


