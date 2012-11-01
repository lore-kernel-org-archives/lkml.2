Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805Ab2KAUYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:24:34 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:58330 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260Ab2KAUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:24:32 -0400
Message-ID: <1351801470.1597.13.camel@x61.thuisdomein>
Subject: [PATCH] [media] budget-av: only use t_state if initialized
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 01 Nov 2012 21:24:30 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Nov 2012 20:24:30.0611 (UTC) FILETIME=[E5DECE30:01CDB86E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building budget-av.o triggers this GCC warning:
    In file included from drivers/media/pci/ttpci/budget-av.c:44:0:
    drivers/media/dvb-frontends/tda8261_cfg.h: In function ‘tda8261_get_bandwidth’:
    drivers/media/dvb-frontends/tda8261_cfg.h:68:21: warning: ‘t_state.bandwidth’ may be used uninitialized in this function [-Wuninitialized]

Move the printk() that uses t_state.bandwith to the location where it
should be initialized to fix this.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) By the way, the first two if()-tests in tda8261_get_bandwidth()
should be superfluous. And the first two if()-tests in both
tda8261_get_frequency() and tda8261_set_frequency() look bogus to me, as
they should always succeed. If that's correct, there are some cleanups
possible in this header.

 drivers/media/dvb-frontends/tda8261_cfg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda8261_cfg.h b/drivers/media/dvb-frontends/tda8261_cfg.h
index 1af1ee4..4671074 100644
--- a/drivers/media/dvb-frontends/tda8261_cfg.h
+++ b/drivers/media/dvb-frontends/tda8261_cfg.h
@@ -78,7 +78,7 @@ static int tda8261_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 			return err;
 		}
 		*bandwidth = t_state.bandwidth;
+		printk("%s: Bandwidth=%d\n", __func__, t_state.bandwidth);
 	}
-	printk("%s: Bandwidth=%d\n", __func__, t_state.bandwidth);
 	return 0;
 }
-- 
1.7.11.7

