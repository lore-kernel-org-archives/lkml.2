Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab0JXS7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 14:59:15 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:59501 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756752Ab0JXS7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 14:59:14 -0400
Date: Sun, 24 Oct 2010 20:57:33 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: ab3550: fix error check
Message-ID: <20101024205733.357ff61e@absol.kitzblitz>
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

It looks to me like it was intended to check the return value
at this point.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/mfd/ab3550-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index 8a98739..b8868cc 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -997,7 +997,7 @@ static ssize_t ab3550_val_write(struct file *file,
 	if (err)
 		return -EINVAL;
 
-	get_register_interruptible(ab, (u8)ab->debug_bank,
+	err = get_register_interruptible(ab, (u8)ab->debug_bank,
 		(u8)ab->debug_address, &regvalue);
 	if (err)
 		return -EINVAL;
-- 
1.7.2.2
