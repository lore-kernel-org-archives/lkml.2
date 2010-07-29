Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab0G2LbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:31:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:44754 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab0G2LbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:31:23 -0400
Date: Thu, 29 Jul 2010 11:31:07 GMT
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dmitry.torokhov@gmail.com, ian.campbell@citrix.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, ian.campbell@citrix.com, tglx@linutronix.de
In-Reply-To: <1280398595-29708-2-git-send-email-ian.campbell@citrix.com>
References: <1280398595-29708-2-git-send-email-ian.campbell@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] ixp4xx-beeper: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupt
Message-ID: <tip-2dd9320305416c171087d5347a6c908ae22c6be1@git.kernel.org>
Git-Commit-ID: 2dd9320305416c171087d5347a6c908ae22c6be1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Jul 2010 11:31:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2dd9320305416c171087d5347a6c908ae22c6be1
Gitweb:     http://git.kernel.org/tip/2dd9320305416c171087d5347a6c908ae22c6be1
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Thu, 29 Jul 2010 11:16:33 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Jul 2010 13:24:57 +0200

ixp4xx-beeper: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupt

ixp4xx_spkr_interrupt is not a timer interrupt and therefore should
not use IRQF_TIMER. Use the recently introduced IRQF_NO_SUSPEND
instead since that is the actual desired behaviour.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
LKML-Reference: <1280398595-29708-2-git-send-email-ian.campbell@citrix.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/input/misc/ixp4xx-beeper.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index 9946d73..9dfd6e5 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -115,7 +115,8 @@ static int __devinit ixp4xx_spkr_probe(struct platform_device *dev)
 	input_dev->event = ixp4xx_spkr_event;
 
 	err = request_irq(IRQ_IXP4XX_TIMER2, &ixp4xx_spkr_interrupt,
-			  IRQF_DISABLED | IRQF_TIMER, "ixp4xx-beeper", (void *) dev->id);
+			  IRQF_DISABLED | IRQF_NO_SUSPEND, "ixp4xx-beeper",
+			  (void *) dev->id);
 	if (err)
 		goto err_free_device;
 
