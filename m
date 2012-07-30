Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab2G3T27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:28:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58617 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab2G3T25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:28:57 -0400
Date: Mon, 30 Jul 2012 21:28:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] serial: sh-sci: fix compilation breakage, when DMA is
 enabled
In-Reply-To: <Pine.LNX.4.64.1207302114440.28003@axis700.grange>
Message-ID: <Pine.LNX.4.64.1207302125390.28003@axis700.grange>
References: <Pine.LNX.4.64.1207302114440.28003@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:AGUUblwLTvw3QZPA8Ls768CN/RPGc7EbdjRg1Pc0ChT
 aDuF8z64d9Sw9KyH+QcM4ZadSvl5ozDaZX+vk8a7TKImNm0zb6
 Otc9/Eq3wdNMN94XBEJorWwE03uuNKIDI46qGnIWbLJycXhvgK
 SRZ5oswl76oClDBUUecXHHIlzIedvm7oQfhb6J4r9na+5BSoYL
 btQdHXUjk+3ECcuLvEi9BJElXUiV6teAtg9j6hYo+7W5d8FyHR
 YgBP7Rh4g9ypK7pef5bDLLGF9v4s2PKfeZGrE0WB7cARoCdX2R
 TbRJrdBYPI28TaAUUrg6wvUz8Eb8H7FsbNC9wIvbFUMjHxg/0d
 bV8b5AcaUWxevqUmcsAZSoqmL8E2cOQ03ctpW0ua8PvarAl6NU
 /hzhWM4KnyCtw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent commit:

commit d6fa5a4e7ab605370fd6c982782f84ef2e6660e7
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    serial: sh-sci: prepare for conversion to the shdma base library

is not sufficient to update the sh-sci driver to the new shdma driver
layout. This caused compilation breakage, when CONFIG_SERIAL_SH_SCI_DMA
is enabled. This patch trivially fixes the problem by updating the DMA
descriptor manipulation code.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/tty/serial/sh-sci.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index d4d8c94..9be296c 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -25,6 +25,7 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/sh_dma.h>
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
@@ -1410,8 +1411,8 @@ static void work_fn_rx(struct work_struct *work)
 		/* Handle incomplete DMA receive */
 		struct tty_struct *tty = port->state->port.tty;
 		struct dma_chan *chan = s->chan_rx;
-		struct sh_desc *sh_desc = container_of(desc, struct sh_desc,
-						       async_tx);
+		struct shdma_desc *sh_desc = container_of(desc,
+					struct shdma_desc, async_tx);
 		unsigned long flags;
 		int count;
 
-- 
1.7.2.5

