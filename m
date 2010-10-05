Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0JESfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:35:07 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:59245 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754314Ab0JESfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:35:05 -0400
Date: Tue, 5 Oct 2010 20:31:54 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Tony Lindgren <tony@atomide.com>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm/omap: simplify conditional
Message-ID: <20101005203154.0ba412d2@absol.kitzblitz>
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

Simplify conditional: (a || (!a && !b)) => (a || !b)

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/arm/plat-omap/fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/fb.c b/arch/arm/plat-omap/fb.c
index 0054b95..5c09095 100644
--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -126,7 +126,7 @@ static int set_fbmem_region_type(struct omapfb_mem_region *rg, int mem_type,
 	 * type = 0 && paddr = 0, a default don't care case maps to
 	 * the SDRAM type.
 	 */
-	if (rg->type || (!rg->type && !rg->paddr))
+	if (rg->type || !rg->paddr)
 		return 0;
 	if (ranges_overlap(rg->paddr, rg->size, mem_start, mem_size)) {
 		rg->type = mem_type;
-- 
1.7.2.2
