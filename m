Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0JGWyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:54:55 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:43151 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992Ab0JGWyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:54:54 -0400
X-ClientAddr: 91.119.5.194
Date: Fri, 8 Oct 2010 00:48:01 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dma/timberdale: simplify conditional
Message-ID: <20101008004801.2f0dee47@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: o97MkW9m001528
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify: ((a && b) || (!a && !b)) => (a == b)

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/dma/timb_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 2ec1ed5..3b88a4e 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -759,7 +759,7 @@ static int __devinit td_probe(struct platform_device *pdev)
 			pdata->channels + i;
 
 		/* even channels are RX, odd are TX */
-		if (((i % 2) && pchan->rx) || (!(i % 2) && !pchan->rx)) {
+		if ((i % 2) == pchan->rx) {
 			dev_err(&pdev->dev, "Wrong channel configuration\n");
 			err = -EINVAL;
 			goto err_tasklet_kill;
-- 
1.7.2.2
