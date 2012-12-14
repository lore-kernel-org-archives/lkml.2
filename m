Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2LNFtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:49:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35511 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab2LNFtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:49:08 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, johnstul@us.ibm.com, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Fri, 14 Dec 2012 14:53:41 +0900
Message-Id: <20121214055341.10081.24472.sendpatchset@w520>
In-Reply-To: <20121214055323.10081.12056.sendpatchset@w520>
References: <20121214055323.10081.12056.sendpatchset@w520>
Subject: [PATCH 02/08] clocksource: sh_cmt: Initialize 'max_match_value' and 'lock' in sh_cmt_setup()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Move the setup of spinlock and max_match_value to sh_cmt_setup().
There's no need to defer those steps until sh_cmt_register().

Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/sh_cmt.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- 0002/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2012-12-14 12:52:35.000000000 +0900
@@ -625,14 +625,6 @@ static int sh_cmt_register(struct sh_cmt
 			   unsigned long clockevent_rating,
 			   unsigned long clocksource_rating)
 {
-	if (p->width == (sizeof(p->max_match_value) * 8))
-		p->max_match_value = ~0;
-	else
-		p->max_match_value = (1 << p->width) - 1;
-
-	p->match_value = p->max_match_value;
-	raw_spin_lock_init(&p->lock);
-
 	if (clockevent_rating)
 		sh_cmt_register_clockevent(p, name, clockevent_rating);
 
@@ -703,6 +695,14 @@ static int sh_cmt_setup(struct sh_cmt_pr
 		p->clear_bits = ~0xc000;
 	}
 
+	if (p->width == (sizeof(p->max_match_value) * 8))
+		p->max_match_value = ~0;
+	else
+		p->max_match_value = (1 << p->width) - 1;
+
+	p->match_value = p->max_match_value;
+	raw_spin_lock_init(&p->lock);
+
 	ret = sh_cmt_register(p, (char *)dev_name(&p->pdev->dev),
 			      cfg->clockevent_rating,
 			      cfg->clocksource_rating);
