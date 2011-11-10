Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab1KJB4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:56:30 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52698 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1KJB43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:56:29 -0500
Message-ID: <1320890178.13074.1.camel@phoenix>
Subject: [PATCH] mfd: add #ifdef CONFIG_DEBUG_FS guard for
 ab8500_debug_resources
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 10 Nov 2011 09:56:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warning if CONFIG_DEBUG_FS is disabled.

  CC      drivers/mfd/ab8500-core.o
drivers/mfd/ab8500-core.c:623: warning: 'ab8500_debug_resources' defined but not used

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/ab8500-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 1e91738..d3d572b 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -620,6 +620,7 @@ static struct resource __devinitdata ab8500_fg_resources[] = {
 
 static struct resource __devinitdata ab8500_chargalg_resources[] = {};
 
+#ifdef CONFIG_DEBUG_FS
 static struct resource __devinitdata ab8500_debug_resources[] = {
 	{
 		.name	= "IRQ_FIRST",
@@ -634,6 +635,7 @@ static struct resource __devinitdata ab8500_debug_resources[] = {
 		.flags	= IORESOURCE_IRQ,
 	},
 };
+#endif
 
 static struct resource __devinitdata ab8500_usb_resources[] = {
 	{
-- 
1.7.5.4



