Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946474Ab2CPXlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:41:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59349 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946443Ab2CPXl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:41:26 -0400
Message-Id: <20120316233813.825485126@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [ 36/41] hwmon: (w83627ehf) Fix temp2 source for W83627UHG
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit aacb6b0052692c72fe0cb94c6b547202def6ef46 upstream.

Properly set the source of temp2 for the W83627UHG. Also fix a
comment right before that, and document the W83627UHG as reporting up
to 3 temperatures.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/hwmon/w83627ehf |    2 +-
 drivers/hwmon/w83627ehf.c     |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/hwmon/w83627ehf
+++ b/Documentation/hwmon/w83627ehf
@@ -50,7 +50,7 @@ W83627DHG, W83627DHG-P, W83627UHG, W8366
 (NCT6775F), and NCT6776F super I/O chips. We will refer to them collectively
 as Winbond chips.
 
-The chips implement 2 to 4 temperature sensors (9 for NCT6775F and NCT6776F),
+The chips implement 3 to 4 temperature sensors (9 for NCT6775F and NCT6776F),
 2 to 5 fan rotation speed sensors, 8 to 10 analog voltage sensors, one VID
 (except for 627UHG), alarms with beep warnings (control unimplemented),
 and some automatic fan regulation strategies (plus manual fan control mode).
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -39,7 +39,7 @@
 					       0x8860 0xa1
     w83627dhg    9      5       4       3      0xa020 0xc1    0x5ca3
     w83627dhg-p  9      5       4       3      0xb070 0xc1    0x5ca3
-    w83627uhg    8      2       2       2      0xa230 0xc1    0x5ca3
+    w83627uhg    8      2       2       3      0xa230 0xc1    0x5ca3
     w83667hg     9      5       3       3      0xa510 0xc1    0x5ca3
     w83667hg-b   9      5       3       4      0xb350 0xc1    0x5ca3
     nct6775f     9      4       3       9      0xb470 0xc1    0x5ca3
@@ -2158,16 +2158,16 @@ static int __devinit w83627ehf_probe(str
 		w83627ehf_set_temp_reg_ehf(data, 3);
 
 		/*
-		 * Temperature sources for temp1 and temp2 are selected with
+		 * Temperature sources for temp2 and temp3 are selected with
 		 * bank 0, registers 0x49 and 0x4a.
 		 */
 		data->temp_src[0] = 0;	/* SYSTIN */
 		reg = w83627ehf_read_value(data, 0x49) & 0x07;
 		/* Adjust to have the same mapping as other source registers */
 		if (reg == 0)
-			data->temp_src[1]++;
+			data->temp_src[1] = 1;
 		else if (reg >= 2 && reg <= 5)
-			data->temp_src[1] += 2;
+			data->temp_src[1] = reg + 2;
 		else	/* should never happen */
 			data->have_temp &= ~(1 << 1);
 		reg = w83627ehf_read_value(data, 0x4a);


