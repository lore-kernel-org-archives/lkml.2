Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0JVKvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:51:25 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:53150 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755537Ab0JVKvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:51:23 -0400
Date: Fri, 22 Oct 2010 12:47:24 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Joern Engel <joern@lazybastard.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] block2mtd: dubious assignment
Message-ID: <20101022124724.59eba464@absol.kitzblitz>
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

When block2mtd_erase fails, a duplicated assignment instantly
changes instr->state from MTD_ERASE_FAILED to MTD_ERASE_DONE.

It looks to me like this might not be intended, or is it?

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/mtd/devices/block2mtd.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 9365186..2cf0cc6 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -91,7 +91,6 @@ static int block2mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
 	} else
 		instr->state = MTD_ERASE_DONE;
 
-	instr->state = MTD_ERASE_DONE;
 	mtd_erase_callback(instr);
 	return err;
 }
-- 
1.7.2.2
