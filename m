Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0IMIma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:42:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64767 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0IMIk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kn/gHLMl7eh/sGzAQCGSoT7KFe6vt8o2WItaGEoJVO0U7fWXLld1LTxZc+hnrGaQGC
         iWuOMgydS0D2xDXz9UjDNEGVHkIuO/0kg2t++YcT6CMrRQAtdiSABawlYxDHSNNg6U/M
         bmcf7mbxK+L6DNJnPGCwGdv8oFgM9wqGiOfIA=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 05/10] staging: octeon: use '%pM' format to print MAC address
Date: Mon, 13 Sep 2010 11:40:29 +0300
Message-Id: <7c2908b7be2a43475c5f83ab78f2523b62c1f4a3.1284316739.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/octeon/ethernet.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index e50a17d..fb568a9 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -465,10 +465,7 @@ int cvm_oct_common_init(struct net_device *dev)
 
 	if (cvm_oct_mac_addr_offset >= octeon_bootinfo->mac_addr_count)
 		printk(KERN_DEBUG "%s: Using MAC outside of the assigned range:"
-			" %02x:%02x:%02x:%02x:%02x:%02x\n", dev->name,
-			sa.sa_data[0] & 0xff, sa.sa_data[1] & 0xff,
-			sa.sa_data[2] & 0xff, sa.sa_data[3] & 0xff,
-			sa.sa_data[4] & 0xff, sa.sa_data[5] & 0xff);
+			" %pM\n", dev->name, sa.sa_data);
 	cvm_oct_mac_addr_offset++;
 
 	/*
-- 
1.7.2.2

