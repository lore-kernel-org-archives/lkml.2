Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab0KOSnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:43:20 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:34894 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989Ab0KOSnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:43:19 -0500
Date: Mon, 15 Nov 2010 19:40:28 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mach-davinci: signedness bug
Message-ID: <20101115194028.30f8b7f0@absol.kitzblitz>
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

aemif_calc_rate() can return a negative error value, so all the
variables that get tested for this value need to be signed.

The maximum bit width of WSETUP(WSETUP_MAX) appears to be 30 bits
(0xf << 26). Using a signed instead of an unsigned integer
shouldn't make a difference here.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/arm/mach-davinci/aemif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
index 9c3f500..1ce70a9 100644
--- a/arch/arm/mach-davinci/aemif.c
+++ b/arch/arm/mach-davinci/aemif.c
@@ -90,7 +90,7 @@ int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
 					void __iomem *base, unsigned cs)
 {
 	unsigned set, val;
-	unsigned ta, rhold, rstrobe, rsetup, whold, wstrobe, wsetup;
+	int ta, rhold, rstrobe, rsetup, whold, wstrobe, wsetup;
 	unsigned offset = A1CR_OFFSET + cs * 4;
 	struct clk *aemif_clk;
 	unsigned long clkrate;
-- 
1.7.2.2
