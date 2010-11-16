Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab0KPJGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:06:32 -0500
Received: from mail.sysgo.com ([195.145.229.155]:39526 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434Ab0KPJGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:06:30 -0500
Date: Tue, 16 Nov 2010 10:07:05 +0100
From: Pavel Machek <pma@sysgo.com>
To: eric.y.miao@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: suspicious code in linux/arch/arm/common/sa1111.c
Message-ID: <20101116090705.GA29337@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is this good idea?

Signed-off-by: Pavel Machek <pma@sysgo.com>

diff -ur linux.ofic//arch/arm/common/sa1111.c linux/arch/arm/common/sa1111.c
--- linux.ofic//arch/arm/common/sa1111.c	2010-10-17 20:31:13.000000000 +0200
+++ linux/arch/arm/common/sa1111.c	2010-11-05 10:44:17.000000000 +0100
@@ -282,7 +312,7 @@
 	for (i = 0; i < 8; i++) {
 		sa1111_writel(ip0 ^ mask, mapbase + SA1111_INTPOL0);
 		sa1111_writel(ip0, mapbase + SA1111_INTPOL0);
-		if (sa1111_readl(mapbase + SA1111_INTSTATCLR1) & mask)
+		if (sa1111_readl(mapbase + SA1111_INTSTATCLR0) & mask)
 			break;
 	}
 
