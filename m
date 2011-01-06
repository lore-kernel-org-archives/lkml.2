Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1AFWYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:24:43 -0500
Received: from kroah.org ([198.145.64.141]:55721 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1AFWYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:24:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/36] serial: apbuart: Fixup apbuart_console_init()
Date: Thu,  6 Jan 2011 14:23:25 -0800
Message-Id: <1294352605-31906-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 35c64e5d (drivers: serial: apbuart: Handle OF failures
gracefully) missed that the modified grlib_apbuart_configure()
function is called from apbuart_console_init() as well.

Fix the fallout.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/apbuart.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/apbuart.c b/drivers/serial/apbuart.c
index 2e84d9c..a30bb962 100644
--- a/drivers/serial/apbuart.c
+++ b/drivers/serial/apbuart.c
@@ -520,11 +520,12 @@ static struct console grlib_apbuart_console = {
 };
 
 
-static void grlib_apbuart_configure(void);
+static int grlib_apbuart_configure(void);
 
 static int __init apbuart_console_init(void)
 {
-	grlib_apbuart_configure();
+	if (grlib_apbuart_configure())
+		return -ENODEV;
 	register_console(&grlib_apbuart_console);
 	return 0;
 }
-- 
1.7.3.2

