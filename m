Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0JROJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:09:55 -0400
Received: from mxout1.idt.com ([157.165.5.25]:55192 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0JROJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:09:52 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH -mm 1/2] RapidIO: Fix maximum port number in tsi57x EM initialization
Date: Mon, 18 Oct 2010 10:03:19 -0400
Message-Id: <1287410600-24783-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace hardcoded maximum port number with actual reported number of
switch ports.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/switches/tsi57x.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/rapidio/switches/tsi57x.c b/drivers/rapidio/switches/tsi57x.c
index d9e9492..2003fb6 100644
--- a/drivers/rapidio/switches/tsi57x.c
+++ b/drivers/rapidio/switches/tsi57x.c
@@ -166,7 +166,8 @@ tsi57x_em_init(struct rio_dev *rdev)
 
 	pr_debug("TSI578 %s [%d:%d]\n", __func__, destid, hopcount);
 
-	for (portnum = 0; portnum < 16; portnum++) {
+	for (portnum = 0;
+	     portnum < RIO_GET_TOTAL_PORTS(rdev->swpinfo); portnum++) {
 		/* Make sure that Port-Writes are enabled (for all ports) */
 		rio_mport_read_config_32(mport, destid, hopcount,
 				TSI578_SP_MODE(portnum), &regval);
-- 
1.7.3.1

