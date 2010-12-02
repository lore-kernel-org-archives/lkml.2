Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab0LBVI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:08:27 -0500
Received: from kroah.org ([198.145.64.141]:54230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029Ab0LBVIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:08:25 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/6] serial8250: Mark console as CON_ANYTIME
Date: Thu,  2 Dec 2010 13:08:18 -0800
Message-Id: <1291324103-7054-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101202204827.GB5927@kroah.com>
References: <20101202204827.GB5927@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

While trying to debug a cpu-hotplug issue I noticed printk() stopped
working once the cpu got marked offline, since the 8250 serial console
doesn't have any per-cpu resources the CON_ANYTIME bit is the safe and
documented way to make it work again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 4d8e14b..09a5508 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2872,7 +2872,7 @@ static struct console serial8250_console = {
 	.device		= uart_console_device,
 	.setup		= serial8250_console_setup,
 	.early_setup	= serial8250_console_early_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER | CON_ANYTIME,
 	.index		= -1,
 	.data		= &serial8250_reg,
 };
-- 
1.7.1

