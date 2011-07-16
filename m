Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1GPCdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 22:33:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63116 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1GPCdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 22:33:16 -0400
Subject: [PATCH] Input: hp_sdc - staticize hp_sdc_kicker()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Brian S. Julin" <bri@calyx.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jul 2011 10:33:08 +0800
Message-ID: <1310783588.2658.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not referenced outside this file so there's no need for it to be in
the global name space.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/serio/hp_sdc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 4220620..979c443 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -795,7 +795,7 @@ int hp_sdc_release_cooked_irq(hp_sdc_irqhook *callback)
 
 /************************* Keepalive timer task *********************/
 
-void hp_sdc_kicker (unsigned long data)
+static void hp_sdc_kicker(unsigned long data)
 {
 	tasklet_schedule(&hp_sdc.task);
 	/* Re-insert the periodic task. */
-- 
1.7.4.1



