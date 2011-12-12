Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1LLD2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:28:36 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:4514
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab1LLD2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:34 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Bob Liu <lliubbo@gmail.com>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH 03/11] blackfin: smp: add suspend and wakeup irq flags
Date: Mon, 12 Dec 2011 11:28:25 +0800
Message-ID: <1323660513-9620-3-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_NO_SUSPEND | IRQF_FORCE_RESUME to irq flags, supplement irq should
not be disabled when system do suspend.

Signed-off-by: Steven Miao <realmz6@gmail.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 arch/blackfin/mach-bf561/smp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
index db22401..b2a6b77 100644
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -114,7 +114,8 @@ void __init platform_request_ipi(int irq, void *handler)
 	int ret;
 	const char *name = (irq == IRQ_SUPPLE_0) ? supple0 : supple1;
 
-	ret = request_irq(irq, handler, IRQF_PERCPU, name, handler);
+	ret = request_irq(irq, handler, IRQF_PERCPU | IRQF_NO_SUSPEND |
+			IRQF_FORCE_RESUME, name, handler);
 	if (ret)
 		panic("Cannot request %s for IPI service", name);
 }
-- 
1.7.0.4


