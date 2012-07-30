Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2G3BKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:10:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab2G3BKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:10:00 -0400
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 30 Jul 2012 11:09:02 +1000
Subject: [PATCH 2/2] Input: twl4030-pwrbutton: report a wakeup_event on button
 press.
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120730010902.22579.94791.stgit@notabene.brown>
In-Reply-To: <20120730010746.22579.52841.stgit@notabene.brown>
References: <20120730010746.22579.52841.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the power button causes a wake from suspend, we need to register
the event with the pm sustem to avoid racing with suspend.

As the input event is reported in the interrupt handler, as simple
pm_wakeup_event() is sufficient.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/input/misc/twl4030-pwrbutton.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index 38e4b50..b3dd96d 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -42,6 +42,7 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
 	err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
 				STS_HW_CONDITIONS);
 	if (!err)  {
+		pm_wakeup_event(pwr->dev.parent, 0);
 		input_report_key(pwr, KEY_POWER, value & PWR_PWRON_IRQ);
 		input_sync(pwr);
 	} else {


