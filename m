Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab1HPRMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:12:08 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:29963
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab1HPRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:12:07 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@suse.de>, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] devtmpfs: Annotate devtmpfsd as __init
Date: Tue, 16 Aug 2011 14:22:35 -0300
Message-ID: <1313515355-28920-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following:

WARNING: vmlinux.o(.text+0x1ed41c): Section mismatch in reference from the function devtmpfsd() to the (unknown reference) .init.data:(unknown)
The function devtmpfsd() references
the (unknown reference) __initdata (unknown).
This is often because devtmpfsd lacks a __initdata 
annotation or the annotation of (unknown) is wrong.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/base/devtmpfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 33e1bed..7bd4860 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -386,7 +386,7 @@ static int handle(const char *name, mode_t mode, struct device *dev)
 		return handle_remove(name, dev);
 }
 
-static int devtmpfsd(void *p)
+static __init int devtmpfsd(void *p)
 {
 	char options[] = "mode=0755";
 	int *err = p;
-- 
1.6.0.4


