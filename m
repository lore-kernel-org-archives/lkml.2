Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab0KOVBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:01:10 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:42091 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758378Ab0KOVBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:01:08 -0500
Date: Mon, 15 Nov 2010 21:59:42 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gianfar: fix signedness issue
Message-ID: <20101115215942.354b0394@absol.kitzblitz>
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

irq_of_parse_and_map() has an unsigned return type.
Testing for a negative error value doesn't work here.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
I see that in numerous places the return value is tested
for NO_IRQ. I hope it's the right thing to do here as well?

 drivers/net/gianfar.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 49e4ce1..d1bec62 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -577,11 +577,10 @@ static int gfar_parse_group(struct device_node *np,
 			irq_of_parse_and_map(np, 1);
 		priv->gfargrp[priv->num_grps].interruptError =
 			irq_of_parse_and_map(np,2);
-		if (priv->gfargrp[priv->num_grps].interruptTransmit < 0 ||
-			priv->gfargrp[priv->num_grps].interruptReceive < 0 ||
-			priv->gfargrp[priv->num_grps].interruptError < 0) {
+		if (priv->gfargrp[priv->num_grps].interruptTransmit == NO_IRQ ||
+		    priv->gfargrp[priv->num_grps].interruptReceive  == NO_IRQ ||
+		    priv->gfargrp[priv->num_grps].interruptError    == NO_IRQ)
 			return -EINVAL;
-		}
 	}
 
 	priv->gfargrp[priv->num_grps].grp_id = priv->num_grps;
-- 
1.7.2.2
