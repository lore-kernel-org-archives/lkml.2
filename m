Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766Ab2EPIr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:47:27 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:18504
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759842Ab2EPIrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:47:18 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] input: rotary: Init wake according to platform pm_wakeup flag.
Date: Wed, 16 May 2012 16:36:23 +0800
Message-ID: <1337157383-13631-1-git-send-email-sonic.zhang@analog.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Rotary can't be used as a wakeup source in all Blackfin processors.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/input/misc/bfin_rotary.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/bfin_rotary.c b/drivers/input/misc/bfin_rotary.c
index 1c4146f..bb1971c 100644
--- a/drivers/input/misc/bfin_rotary.c
+++ b/drivers/input/misc/bfin_rotary.c
@@ -182,7 +182,7 @@ static int __devinit bfin_rotary_probe(struct platform_device *pdev)
 	bfin_write_CNT_CONFIG(bfin_read_CNT_CONFIG() | CNTE);
 
 	platform_set_drvdata(pdev, rotary);
-	device_init_wakeup(&pdev->dev, 1);
+	device_init_wakeup(&pdev->dev, pdata->pm_wakeup);
 
 	return 0;
 
-- 
1.7.0.4


