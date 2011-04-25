Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1DYNpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 09:45:44 -0400
Received: from relay.pcl-ipout01.plus.net ([212.159.7.99]:46253 "EHLO
	relay.pcl-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139Ab1DYNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 09:45:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUoAMh5tU1UXeb6/2dsb2JhbACCNIJekkkxjSh3sT8ChmKJFw6FaASSPYJWgRQ
Subject: [PATCH] ds2760_battery: Fix rated capacity of the hx4700 1800mAh battery
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cbou@mail.ru>, <dwmw2@infradead.org>
Date: Mon, 25 Apr 2011 13:45:40 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.38 x86_64 [http://email.cleancode.org])
Message-Id: <E1QEM6f-0000Db-K0@outmx05.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix rated capacity of the HP iPAQ hx4700 3.7V 1800mAh (359113-001) battery. For this battery the value of the rated capacity EEPROM register at 0x32 is 7; thus rated_capacities[7] = 1800.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---
--- clean-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-03-15 01:20:32.000000000 +0000
+++ linux-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-04-25 13:06:29.344976841 +0100
@@ -86,7 +86,11 @@ static int rated_capacities[] = {
 	920,	/* NEC */
 	1440,	/* Samsung */
 	1440,	/* BYD */
+#ifdef CONFIG_MACH_H4700
+	1800,	/* HP iPAQ hx4700 3.7V 1800mAh (359113-001) */
+#else
 	1440,	/* Lishen */
+#endif
 	1440,	/* NEC */
 	2880,	/* Samsung */
 	2880,	/* BYD */

