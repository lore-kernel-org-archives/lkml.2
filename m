Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0DVQvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:51:08 -0400
Received: from compulab.co.il ([67.18.134.219]:54229 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab0DVQvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:51:06 -0400
Message-ID: <4BD07E3B.3030504@compulab.co.il>
Date: Thu, 22 Apr 2010 19:50:03 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Wim Van Sebroeck <wim@iguana.be>, Andrey Panin <pazke@centrinvest.ru>
Subject: I/O operations order fix for SBC-FITPC2 watchdog
References: <4A6492EB.1080709@compulab.co.il> <4AF2B7D8.1010903@compulab.co.il> <4B58603F.5030407@compulab.co.il>
In-Reply-To: <4B58603F.5030407@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sbc_fitpc2_wdt: fixed I/O operations order

There are fitpc2 compatible boards that hang with existent i/o
operations order. Solution is to switch between writing to data
and command ports.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/watchdog/sbc_fitpc2_wdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index 8d44c9b..226f0f2 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -45,10 +45,10 @@ static DEFINE_SPINLOCK(wdt_lock);

 static void wdt_send_data(unsigned char command, unsigned char data)
 {
-	outb(command, COMMAND_PORT);
-	msleep(100);
 	outb(data, DATA_PORT);
 	msleep(200);
+	outb(command, COMMAND_PORT);
+	msleep(100);	
 }

 static void wdt_enable(void)
