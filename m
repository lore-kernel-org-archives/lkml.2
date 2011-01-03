Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1ACC3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 21:29:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38313 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1ACC3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 21:29:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EotXQZlPHIIbY7e0XnZO4BOnNosBtx36FJDRj4cq7udJaka9AJOO4h8fKw/Vz2bkA6
         +d//Ue7n/6E8fjjfqSc0XzIG0Q9GVdXJvA/GIcO31isVa1ev7JkP8Rl+nQhI6QxRJQOg
         4f789wemBW2LUkIBNSN4PPlYo1raeIiufPt0A=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] smsc-ircc2: Fix section mismatch derived from smsc_ircc_pnp_driver variable
Date: Mon,  3 Jan 2011 03:28:44 +0100
Message-Id: <1294021724-30337-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From my build.log:

drivers/net/irda/smsc-ircc2.o(.data+0x18): Section mismatch in reference from the variable smsc_ircc_pnp_driver to the function .init.text:smsc_ircc_pnp_probe()
The variable smsc_ircc_pnp_driver references
the function __init smsc_ircc_pnp_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

This patch fixes the warning.

Tested with linux-next (next-20101231)

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/irda/smsc-ircc2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index 8c57bfb..0ebd4a8 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -397,7 +397,7 @@ static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
 	return 0;
 }
 
-static struct pnp_driver smsc_ircc_pnp_driver = {
+static struct pnp_driver smsc_ircc_pnp_driver __refdata = {
 	.name		= "smsc-ircc2",
 	.id_table	= smsc_ircc_pnp_table,
 	.probe		= smsc_ircc_pnp_probe,
-- 
1.7.4.rc0

