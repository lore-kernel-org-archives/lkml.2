Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab1DYOnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:43:46 -0400
Received: from relay.pcl-ipout02.plus.net ([212.159.7.100]:57082 "EHLO
	relay.pcl-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758278Ab1DYOnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:43:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUoAIWItU3Unw4T/2dsb2JhbACCNIJekkkxjSh3sgMChmWJFw6FaASSPYJWgRQ
Subject: [PATCH] ds2760_battery: Fix indexing of the 4 active full EEPROM registers
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cbou@mail.ru>, <dwmw2@infradead.org>
Date: Mon, 25 Apr 2011 14:43:30 +0000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.38 x86_64 [http://email.cleancode.org])
Message-Id: <E1QEN0d-0007iM-LV@outmx04.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix indexing of the 4 active full EEPROM registers. The indexing was out by 1, accessing the EEPROM registers at 0x23 to 0x26 instead of 0x22 to 0x25.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---
--- clean-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-03-15 01:20:32.000000000 +0000
+++ linux-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-04-25 13:06:29.344976841 +0100
@@ -186,7 +190,7 @@ static int ds2760_battery_read_status(st
 
 	scale[0] = di->full_active_uAh;
 	for (i = 1; i < 5; i++)
-		scale[i] = scale[i - 1] + di->raw[DS2760_ACTIVE_FULL + 2 + i];
+		scale[i] = scale[i - 1] + di->raw[DS2760_ACTIVE_FULL + 1 + i];
 
 	di->full_active_uAh = battery_interpolate(scale, di->temp_C / 10);
 	di->full_active_uAh *= 1000; /* convert to µAh */

