Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab2HUQjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:39:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2HUQi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:38:58 -0400
Date: Tue, 21 Aug 2012 09:38:39 -0700
From: tip-bot for Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Message-ID: <tip-b3ae66f209e8929db62b5a5f874ab2cdcf5ef1d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kuninori.morimoto.gx@renesas.com, gregkh@linuxfoundation.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, linus.walleij@linaro.org
Reply-To: gregkh@linuxfoundation.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, tglx@linutronix.de,
        kuninori.morimoto.gx@renesas.com, linus.walleij@linaro.org
In-Reply-To: <873948trpk.wl%kuninori.morimoto.gx@renesas.com>
References: <873948trpk.wl%kuninori.morimoto.gx@renesas.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Export irq_set_chip_and_handler_name()
Git-Commit-ID: b3ae66f209e8929db62b5a5f874ab2cdcf5ef1d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:38:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3ae66f209e8929db62b5a5f874ab2cdcf5ef1d4
Gitweb:     http://git.kernel.org/tip/b3ae66f209e8929db62b5a5f874ab2cdcf5ef1d4
Author:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
AuthorDate: Mon, 30 Jul 2012 22:39:06 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 21 Aug 2012 16:14:23 +0200

genirq: Export irq_set_chip_and_handler_name()

Export irq_set_chip_and_handler_name() to modules to allow them to
do things such as

	irq_set_chip_and_handler(....);

This fixes

	ERROR: "irq_set_chip_and_handler_name" \
	          [drivers/gpio/gpio-pcf857x.ko] undefined!

when gpio-pcf857x.c is being built as a module.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <gregkh@linuxfoundation.org>
Link: http://lkml.kernel.org/r/873948trpk.wl%25kuninori.morimoto.gx@renesas.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index eebd6d5..57d86d0 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -671,6 +671,7 @@ irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 	irq_set_chip(irq, chip);
 	__irq_set_handler(irq, handle, 0, name);
 }
+EXPORT_SYMBOL_GPL(irq_set_chip_and_handler_name);
 
 void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 {
