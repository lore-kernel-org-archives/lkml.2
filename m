Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0IKORq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 10:17:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62351 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0IKORi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 10:17:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m0oIHbHg2vK3ivqmi7xmohkynEbD2V2fiLSeZq+g3FBlSgYHbr5x19v/CCJHHF9evY
         EzlWgCcWfolZIox1Bx0U0u511Sst39ePE0LHYbhjJqVtcWeH2gETGgNPzvD4UyZSl7YE
         Z27rkJ98OYW/T3sA/pK2/eQTxk7yvKuyu+2sg=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 05/10] staging: octeon: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 17:17:08 +0300
Message-Id: <5c15520491761c2ae1616429f0bf8cfda77f41b6.1284214460.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/octeon/ethernet.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index e50a17d..9537ea4 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -465,10 +465,7 @@ int cvm_oct_common_init(struct net_device *dev)
 
 	if (cvm_oct_mac_addr_offset >= octeon_bootinfo->mac_addr_count)
 		printk(KERN_DEBUG "%s: Using MAC outside of the assigned range:"
-			" %02x:%02x:%02x:%02x:%02x:%02x\n", dev->name,
-			sa.sa_data[0] & 0xff, sa.sa_data[1] & 0xff,
-			sa.sa_data[2] & 0xff, sa.sa_data[3] & 0xff,
-			sa.sa_data[4] & 0xff, sa.sa_data[5] & 0xff);
+			" %pM\n", dev->name, &sa.sa_data[0]);
 	cvm_oct_mac_addr_offset++;
 
 	/*
-- 
1.7.2.2

