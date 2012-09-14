Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2INCbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:31:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38568 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2INCbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:31:00 -0400
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 10:30:59 +0800
Message-ID: <CAPgLHd-ac3JYu4SEQd0pPO-YBW4kM+DqcjHs3QzPdLWqc+CXfw@mail.gmail.com>
Subject: [PATCH] ARM: mmp: using for_each_set_bit to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: eric.y.miao@gmail.com, haojian.zhuang@gmail.com, linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using for_each_set_bit() to simplify the code.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-mmp/irq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/mach-mmp/irq.c b/arch/arm/mach-mmp/irq.c
index e60c7d9..3c71246 100644
--- a/arch/arm/mach-mmp/irq.c
+++ b/arch/arm/mach-mmp/irq.c
@@ -153,10 +153,8 @@ static void icu_mux_irq_demux(unsigned int irq, struct irq_desc *desc)
 		status = readl_relaxed(data->reg_status) & ~mask;
 		if (status == 0)
 			break;
-		n = find_first_bit(&status, BITS_PER_LONG);
-		while (n < BITS_PER_LONG) {
+		for_each_set_bit(n, &status, BITS_PER_LONG) {
 			generic_handle_irq(icu_data[i].virq_base + n);
-			n = find_next_bit(&status, BITS_PER_LONG, n + 1);
 		}
 	}
 }

