Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0JYMnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:43:00 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:53182 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877Ab0JYMnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:43:00 -0400
Date: Mon, 25 Oct 2010 14:41:18 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] davinci: simplify if-statement
Message-ID: <20101025144118.62ec420c@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common do-while loop can be factored out from the end of
the branches.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/arm/mach-davinci/psc.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-davinci/psc.c b/arch/arm/mach-davinci/psc.c
index 1b15dbd..a415804 100644
--- a/arch/arm/mach-davinci/psc.c
+++ b/arch/arm/mach-davinci/psc.c
@@ -83,21 +83,16 @@ void davinci_psc_config(unsigned int domain, unsigned int ctlr,
 		pdctl1 = __raw_readl(psc_base + PDCTL1);
 		pdctl1 |= 0x100;
 		__raw_writel(pdctl1, psc_base + PDCTL1);
-
-		do {
-			ptstat = __raw_readl(psc_base +
-					       PTSTAT);
-		} while (!(((ptstat >> domain) & 1) == 0));
 	} else {
 		ptcmd = 1 << domain;
 		__raw_writel(ptcmd, psc_base + PTCMD);
-
-		do {
-			ptstat = __raw_readl(psc_base + PTSTAT);
-		} while (!(((ptstat >> domain) & 1) == 0));
 	}
 
 	do {
+		ptstat = __raw_readl(psc_base + PTSTAT);
+	} while (!(((ptstat >> domain) & 1) == 0));
+
+	do {
 		mdstat = __raw_readl(psc_base + MDSTAT + 4 * id);
 	} while (!((mdstat & MDSTAT_STATE_MASK) == next_state));
 
-- 
1.7.2.2
