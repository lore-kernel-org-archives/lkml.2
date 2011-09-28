Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab1I1XQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:16:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486Ab1I1WnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:37 2011
Message-Id: <20110928220137.448152320@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [115/244] mfd: Fix initialisation of tps65910 interrupts
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit fa948761e685fb03823b3029e5b6bdb52229d6ce upstream.

Fix regression introduced by commit
a2974732ca7614aaf0baf9d6dd3ad893d50ce1c5 (TPS65911: Add new irq
definitions) which caused irq_num to be incorrectly set for tps65910.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/tps65910-irq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -178,8 +178,10 @@ int tps65910_irq_init(struct tps65910 *t
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
 		tps65910->irq_num = TPS65910_NUM_IRQ;
+		break;
 	case TPS65911:
 		tps65910->irq_num = TPS65911_NUM_IRQ;
+		break;
 	}
 
 	/* Register with genirq */


