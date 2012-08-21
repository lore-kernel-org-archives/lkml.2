Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab2HUQjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:39:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33133 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2HUQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:39:50 -0400
Date: Tue, 21 Aug 2012 09:39:34 -0700
From: tip-bot for Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Message-ID: <tip-17d83127d4c2b322dd8f217e0ac08c66eb403779@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kuninori.morimoto.gx@renesas.com, gregkh@linuxfoundation.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, linus.walleij@linaro.org
Reply-To: gregkh@linuxfoundation.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, tglx@linutronix.de,
        kuninori.morimoto.gx@renesas.com, linus.walleij@linaro.org
In-Reply-To: <871ujstrp6.wl%kuninori.morimoto.gx@renesas.com>
References: <871ujstrp6.wl%kuninori.morimoto.gx@renesas.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Export dummy_irq_chip
Git-Commit-ID: 17d83127d4c2b322dd8f217e0ac08c66eb403779
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:39:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17d83127d4c2b322dd8f217e0ac08c66eb403779
Gitweb:     http://git.kernel.org/tip/17d83127d4c2b322dd8f217e0ac08c66eb403779
Author:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
AuthorDate: Mon, 30 Jul 2012 22:39:20 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 21 Aug 2012 16:14:23 +0200

genirq: Export dummy_irq_chip

Export dummy_irq_chip to modules to allow them to do things such as

	irq_set_chip_and_handler(virq,
				 &dummy_irq_chip,
				 handle_level_irq);
This fixes

	ERROR: "dummy_irq_chip" [drivers/gpio/gpio-pcf857x.ko] undefined!

when gpio-pcf857x.c is being built as a module.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <gregkh@linuxfoundation.org>
Link: http://lkml.kernel.org/r/871ujstrp6.wl%25kuninori.morimoto.gx@renesas.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/dummychip.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/dummychip.c b/kernel/irq/dummychip.c
index b5fcd96..988dc58 100644
--- a/kernel/irq/dummychip.c
+++ b/kernel/irq/dummychip.c
@@ -6,6 +6,7 @@
  */
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/export.h>
 
 #include "internals.h"
 
@@ -57,3 +58,4 @@ struct irq_chip dummy_irq_chip = {
 	.irq_mask	= noop,
 	.irq_unmask	= noop,
 };
+EXPORT_SYMBOL_GPL(dummy_irq_chip);
