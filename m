Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1KSL3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:29:52 -0500
Received: from www17.your-server.de ([213.133.104.17]:41083 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab1KSL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:29:41 -0500
Subject: [PATCH] [SCSI] mptfusion: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.287.camel@localhost.localdomain>
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

diff -u -p a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c 2011-11-07 19:37:51.796676955 +0100
+++ b/drivers/message/fusion/mptbase.c 2011-11-08 10:40:23.121014643 +0100
@@ -6003,13 +6003,12 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 	if (mpt_config(ioc, &cfg) != 0)
 		goto out;
 
-	mem = kmalloc(iocpage2sz, GFP_KERNEL);
+	mem = kmemdup((u8 *)pIoc2, iocpage2sz, GFP_KERNEL);
 	if (!mem) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	memcpy(mem, (u8 *)pIoc2, iocpage2sz);
 	ioc->raid_data.pIocPg2 = (IOCPage2_t *) mem;
 
 	mpt_read_ioc_pg_3(ioc);
