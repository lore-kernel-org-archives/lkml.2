Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab2K0JrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:47:23 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:53834 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758342Ab2K0JrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:47:20 -0500
Message-ID: <1354009637.1420.50.camel@x61.thuisdomein>
Subject: [PATCH 1/2] ewrk3: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Date: Tue, 27 Nov 2012 10:47:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Nov 2012 09:47:17.0655 (UTC) FILETIME=[2FFE3270:01CDCC84]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building ewrk3.o triggers this GCC warning:
    drivers/net/ethernet/dec/ewrk3.c: In function '__check_irq':
    drivers/net/ethernet/dec/ewrk3.c:1915:1: warning: return from incompatible pointer type [enabled by default]

This can be trivially fixed by changing the 'irq' parameter from int to
byte (which is an alias for unsigned char for module parameters).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Only compile tested.

 drivers/net/ethernet/dec/ewrk3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/dec/ewrk3.c b/drivers/net/ethernet/dec/ewrk3.c
index 17ae8c6..2ee1c47 100644
--- a/drivers/net/ethernet/dec/ewrk3.c
+++ b/drivers/net/ethernet/dec/ewrk3.c
@@ -1912,7 +1912,7 @@ static int io[MAX_NUM_EWRK3S+1] = { 0x300, 0, };
 
 /* '21' below should really be 'MAX_NUM_EWRK3S' */
 module_param_array(io, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, byte, NULL, 0);
 MODULE_PARM_DESC(io, "EtherWORKS 3 I/O base address(es)");
 MODULE_PARM_DESC(irq, "EtherWORKS 3 IRQ number(s)");
 
-- 
1.7.7.6

