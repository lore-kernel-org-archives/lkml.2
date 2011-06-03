Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1FCBIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:08:32 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1094 "EHLO
	smtp-out-212.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1FCBIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:08:31 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8419
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/4] MIPS: JZ4740: GPIO: Check correct IRQ in demux handler
Date: Fri,  3 Jun 2011 03:06:51 +0200
Message-Id: <1307063211-10098-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307063211-10098-1-git-send-email-lars@metafoo.de>
References: <1307063211-10098-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the trigger direction for the triggered IRQ instead of the parent IRQ.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/jz4740/gpio.c b/arch/mips/jz4740/gpio.c
index f3590a2..7179c78 100644
--- a/arch/mips/jz4740/gpio.c
+++ b/arch/mips/jz4740/gpio.c
@@ -309,7 +309,7 @@ static void jz_gpio_irq_demux_handler(unsigned int irq, struct irq_desc *desc)
 
 	gpio_irq = chip->irq_base + __fls(flag);
 
-	jz_gpio_check_trigger_both(chip, irq);
+	jz_gpio_check_trigger_both(chip, gpio_irq);
 
 	generic_handle_irq(gpio_irq);
 };
-- 
1.7.2.5

