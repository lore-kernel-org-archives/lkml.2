Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab0KSA20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:28:26 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:35073 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758097Ab0KSA2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:28:25 -0500
Date: Fri, 19 Nov 2010 01:24:02 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        irda-users@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] SuperH IrDA: correct Baud rate error correction
Message-ID: <20101119012402.43e9aa61@absol.kitzblitz>
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

It looks to me as if the second value of rate_err_array is intended
to be a decimal 625. However, with a leading 0 it becomes an octal
constant, and as such evaluates to a decimal 405.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/net/irda/sh_sir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/sh_sir.c b/drivers/net/irda/sh_sir.c
index 00b38bc..52a7c86 100644
--- a/drivers/net/irda/sh_sir.c
+++ b/drivers/net/irda/sh_sir.c
@@ -258,7 +258,7 @@ static int sh_sir_set_baudrate(struct sh_sir_self *self, u32 baudrate)
 
 	/* Baud Rate Error Correction x 10000 */
 	u32 rate_err_array[] = {
-		0000, 0625, 1250, 1875,
+		   0,  625, 1250, 1875,
 		2500, 3125, 3750, 4375,
 		5000, 5625, 6250, 6875,
 		7500, 8125, 8750, 9375,
-- 
1.7.2.2
