Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0IEScX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:32:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0IEScW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=A0COAdYmekzzZGGOYRC0ZicFFIwisismtbaJK7BtbvqoCfxAE3xGmDy50tInyulDf0
         B+kh16nHTecLmBSuWJhE6fNqUts/lo3ado++tJbtkUj2UOSv8uq7vrRf0hJgmr5tcw48
         1VBn9ekeyatPLIz20jcY218wk6FpQULeaggLg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] avr32/mach-at32ap/clock: check return code of clk_get
Date: Sun,  5 Sep 2010 22:32:15 +0400
Message-Id: <1283711535-7082-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function clk_get may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 arch/avr32/mach-at32ap/clock.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/clock.c b/arch/avr32/mach-at32ap/clock.c
index 442f08c..133a475 100644
--- a/arch/avr32/mach-at32ap/clock.c
+++ b/arch/avr32/mach-at32ap/clock.c
@@ -258,14 +258,20 @@ static int clk_show(struct seq_file *s, void *unused)
 
 	/* show clock tree as derived from the three oscillators */
 	clk = clk_get(NULL, "osc32k");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 	dump_clock(clk, &r);
 	clk_put(clk);
 
 	clk = clk_get(NULL, "osc0");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 	dump_clock(clk, &r);
 	clk_put(clk);
 
 	clk = clk_get(NULL, "osc1");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 	dump_clock(clk, &r);
 	clk_put(clk);
 
-- 
1.7.0.4

