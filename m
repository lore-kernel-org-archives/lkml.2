Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0JVQNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:13:46 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:33590 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab0JVQNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:13:45 -0400
Date: Fri, 22 Oct 2010 18:10:24 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Harald Welte <laforge@gnumonks.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia/cm4000: fix error code
Message-ID: <20101022181024.534fdd15@absol.kitzblitz>
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

I'm assuming it's not intended to instantly change the error code
from -ENODEV to -EIO, is it?

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/char/pcmcia/cm4000_cs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index d962f25..777181a 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -979,8 +979,9 @@ static ssize_t cmm_read(struct file *filp, __user char *buf, size_t count,
 		if (dev->flags0 & 1) {
 			set_bit(IS_CMM_ABSENT, &dev->flags);
 			rc = -ENODEV;
+		} else {
+			rc = -EIO;
 		}
-		rc = -EIO;
 		goto release_io;
 	}
 
-- 
1.7.2.2
