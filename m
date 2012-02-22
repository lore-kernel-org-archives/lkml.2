Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2BVNHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:07:00 -0500
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:49777 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752195Ab2BVNG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:06:59 -0500
Subject: [PATCH] tg3: remove IRQF_SAMPLE_RANDOM flag
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Wed, 22 Feb 2012 14:06:54 +0100
Message-ID: <1329916014.2586.2.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

This driver is the last user of the IRQF_SAMPLE_RANDOM flag for net drivers, and since add_*_randomness
interfaces have now deprecated the flag as a source of external noise, we can remove it.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index a1f2e0f..2badfc3 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -9401,7 +9401,7 @@ static int tg3_test_interrupt(struct tg3 *tp)
 	}
 
 	err = request_irq(tnapi->irq_vec, tg3_test_isr,
-			  IRQF_SHARED | IRQF_SAMPLE_RANDOM, dev->name, tnapi);
+			  IRQF_SHARED, dev->name, tnapi);
 	if (err)
 		return err;
 
-- 
1.7.4.1



