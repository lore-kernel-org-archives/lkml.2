Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1ICCD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 22:03:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54117 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1ICCDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 22:03:22 -0400
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH] =?UTF-8?q?drivers/isdn/sc/init.c:=20Fix=20warning:passing=20argument=201=20of=20=E2=80=98readl=E2=80=99=20makes=20pointer=20from=20integer=20without=20a=20cast?=
Date: Sat,  3 Sep 2011 10:02:19 +0800
Message-Id: <1315015339-2501-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/sc/init.c:487: warning: passing argument 1 of ‘readl’ makes pointer from integer without a cast
/home/harvey/Projects/linux-kernel/linux-2.6/arch/x86/include/asm/io.h:55: note: expected ‘const volatile void *’ but argument is of type ‘long unsigned int’
drivers/isdn/sc/init.c:497: warning: passing argument 1 of ‘readl’ makes pointer from integer without a cast
/home/harvey/Projects/linux-kernel/linux-2.6/arch/x86/include/asm/io.h:55: note: expected ‘const volatile void *’ but argument is of type ‘long unsigned int’
drivers/isdn/sc/init.c:507: warning: passing argument 1 of ‘readl’ makes pointer from integer without a cast
/home/harvey/Projects/linux-kernel/linux-2.6/arch/x86/include/asm/io.h:55: note: expected ‘const volatile void *’ but argument is of type ‘long unsigned int’

Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
---
 drivers/isdn/sc/init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index ca710ab..d3db30d 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -484,7 +484,7 @@ static int identify_board(unsigned long rambase, unsigned int iobase)
 	 */
 	outb(PRI_BASEPG_VAL, pgport);
 	msleep_interruptible(1000);
-	sig = readl(rambase + SIG_OFFSET);
+	sig = readl((const volatile void *)(rambase + SIG_OFFSET));
 	pr_debug("Looking for a signature, got 0x%lx\n", sig);
 	if(sig == SIGNATURE)
 		return PRI_BOARD;
@@ -494,7 +494,7 @@ static int identify_board(unsigned long rambase, unsigned int iobase)
 	 */
 	outb(BRI_BASEPG_VAL, pgport);
 	msleep_interruptible(1000);
-	sig = readl(rambase + SIG_OFFSET);
+	sig = readl((const volatile void *)(rambase + SIG_OFFSET));
 	pr_debug("Looking for a signature, got 0x%lx\n", sig);
 	if(sig == SIGNATURE)
 		return BRI_BOARD;
@@ -504,7 +504,7 @@ static int identify_board(unsigned long rambase, unsigned int iobase)
 	/*
 	 * Try to spot a card
 	 */
-	sig = readl(rambase + SIG_OFFSET);
+	sig = readl((const volatile void *)(rambase + SIG_OFFSET));
 	pr_debug("Looking for a signature, got 0x%lx\n", sig);
 	if(sig != SIGNATURE)
 		return -1;
-- 
1.7.2.5

