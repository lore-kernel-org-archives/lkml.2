Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0KZRGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:06:39 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42343 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0KZRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:06:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=GoeYEoKFfEK2st4eCXPZFW16CzVu8MVvPN8lavwAVJDkSsgURgCzpNzOYb+7VeAEBe
         8G50AIkDkfZ7c94fZFBfJUdY4KTCNB2JykvX1eCA49Z/n0VX16zRAwVT0iUATbgC+L1c
         p6eMtNQ317NMQc9TncdmahCqlbCjRfd9w7dLM=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Magnus Damm <damm@opensource.se>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sh: boards: mach-se: use IS_ERR() instead of NULL check
Date: Fri, 26 Nov 2010 20:06:28 +0300
Message-Id: <1290791190-21358-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns ERR_PTR() on error, not NULL.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 arch/sh/boards/mach-se/7724/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
index c31d228..6735305 100644
--- a/arch/sh/boards/mach-se/7724/setup.c
+++ b/arch/sh/boards/mach-se/7724/setup.c
@@ -871,14 +871,14 @@ static int __init devices_setup(void)
 
 	/* set SPU2 clock to 83.4 MHz */
 	clk = clk_get(NULL, "spu_clk");
-	if (clk) {
+	if (!IS_ERR(clk)) {
 		clk_set_rate(clk, clk_round_rate(clk, 83333333));
 		clk_put(clk);
 	}
 
 	/* change parent of FSI A */
 	clk = clk_get(NULL, "fsia_clk");
-	if (clk) {
+	if (!IS_ERR(clk)) {
 		clk_register(&fsimcka_clk);
 		clk_set_parent(clk, &fsimcka_clk);
 		clk_set_rate(clk, 11000);
-- 
1.7.0.4

