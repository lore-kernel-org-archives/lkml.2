Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492Ab1LPS0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:26:32 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:61182 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760362Ab1LPSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:25:42 -0500
From: David Decotigny <decot@googlers.com>
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Robin Getz <rgetz@blackfin.uclinux.org>,
        Matt Mackall <mpm@selenic.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        David Decotigny <decot@googlers.com>
Subject: [PATCH net-next v1 2/6] tg3: Remove IRQF_SAMPLE_RANDOM flag from internal tests
Date: Fri, 16 Dec 2011 10:19:45 -0800
Message-Id: <e5a227a4cf2782ff8f73886dbc5ca0fb8fad9c8a.1324059527.git.decot@googlers.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1324059527.git.decot@googlers.com>
References: <cover.1324059527.git.decot@googlers.com>
In-Reply-To: <cover.1324059527.git.decot@googlers.com>
References: <cover.1324059527.git.decot@googlers.com>
Organization: Google, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This complements commit ab392d2d6d4 ("Remove IRQF_SAMPLE_RANDOM flag
from network drivers"), removing IRQF_SAMPLE_RANDOM flag from internal
and self tests.

Tested: no visible regression on 1 actual host + ethtool -t passes.


Signed-off-by: David Decotigny <decot@googlers.com>
---
 drivers/net/ethernet/broadcom/tg3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index e04c4f9..a65b419 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -9387,7 +9387,7 @@ static int tg3_test_interrupt(struct tg3 *tp)
 	}
 
 	err = request_irq(tnapi->irq_vec, tg3_test_isr,
-			  IRQF_SHARED | IRQF_SAMPLE_RANDOM, dev->name, tnapi);
+			  IRQF_SHARED, dev->name, tnapi);
 	if (err)
 		return err;
 
-- 
1.7.3.1

