Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab1KRJ1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:27:25 -0500
Received: from www17.your-server.de ([213.133.104.17]:48417 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab1KRJ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:27:22 -0500
Subject: [PATCH] x86, mrst: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.277.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
--- a/arch/x86/platform/mrst/mrst.c 2011-11-07 19:37:40.283168752 +0100
+++ b/arch/x86/platform/mrst/mrst.c 2011-11-08 11:01:48.424910801 +0100
@@ -656,13 +656,12 @@ static void __init intel_scu_spi_device_
 		return;
 	}
 
-	new_dev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	new_dev = kmemdup(sdev, sizeof(*sdev), GFP_KERNEL);
 	if (!new_dev) {
 		pr_err("failed to alloc mem for delayed spi dev %s\n",
 			sdev->modalias);
 		return;
 	}
-	memcpy(new_dev, sdev, sizeof(*sdev));
 
 	spi_devs[spi_next_dev++] = new_dev;
 }
@@ -677,13 +676,12 @@ static void __init intel_scu_i2c_device_
 		return;
 	}
 
-	new_dev = kzalloc(sizeof(*idev), GFP_KERNEL);
+	new_dev = kmemdup(idev, sizeof(*idev), GFP_KERNEL);
 	if (!new_dev) {
 		pr_err("failed to alloc mem for delayed i2c dev %s\n",
 			idev->type);
 		return;
 	}
-	memcpy(new_dev, idev, sizeof(*idev));
 
 	i2c_bus[i2c_next_dev] = bus;
 	i2c_devs[i2c_next_dev++] = new_dev;
