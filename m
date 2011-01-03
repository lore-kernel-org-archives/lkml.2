Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1ACKcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:32:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36379 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1ACKcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:32:41 -0500
From: Michal Simek <monstr@monstr.eu>
To: grant.likely@secretlab.ca
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, davem@davemloft.net,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH] ll_temac: Fix section mismatch from the temac_of_probe
Date: Mon,  3 Jan 2011 11:32:36 +0100
Message-Id: <1294050756-31099-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace __init by __devinit.

Warning message:
WARNING: vmlinux.o(.data+0xbc14): Section mismatch in reference from the variable
temac_of_driver to the function .init.text:temac_of_probe()
The variable temac_of_driver references
the function __init temac_of_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/net/ll_temac_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index 9f8e702..beb6ed8 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -952,7 +952,7 @@ static const struct attribute_group temac_attr_group = {
 	.attrs = temac_device_attrs,
 };
 
-static int __init
+static int __devinit
 temac_of_probe(struct platform_device *op, const struct of_device_id *match)
 {
 	struct device_node *np;
-- 
1.5.5.6

