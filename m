Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1ACVQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:16:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36542 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1ACVQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:16:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EPJ3aw88HjLXwNlMmUQlyasE5GZDLC64QLrtBmppLdc3CmI6uEmS6yhq3z6fFr9Yw4
         GsC1OZTx0XnsgQ6bS4bt1VF0EkfwDOeQ4x75wZOOO1AZOfJgmNlXhC8ceGebW4ltsXyg
         h/x5RPSMqoq4HjumZwV+cIkGBh0juGgeLsolo=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] smsc-ircc2: Fix section mismatch derived from smsc_ircc_pnp_probe()
Date: Mon,  3 Jan 2011 22:15:58 +0100
Message-Id: <1294089358-2968-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following warning:

drivers/net/irda/smsc-ircc2.o(.data+0x18): Section mismatch in reference from the variable smsc_ircc_pnp_driver to the function .init.text:smsc_ircc_pnp_probe()
The variable smsc_ircc_pnp_driver references
the function __init smsc_ircc_pnp_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Tested with linux-next (next-20101231)

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/irda/smsc-ircc2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index 8c57bfb..1c1677c 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -376,7 +376,7 @@ MODULE_DEVICE_TABLE(pnp, smsc_ircc_pnp_table);
 static int pnp_driver_registered;
 
 #ifdef CONFIG_PNP
-static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
+static int __devinit smsc_ircc_pnp_probe(struct pnp_dev *dev,
 				      const struct pnp_device_id *dev_id)
 {
 	unsigned int firbase, sirbase;
-- 
1.7.4.rc0

