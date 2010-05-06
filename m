Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0EFDue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 23:50:34 -0400
Received: from trinity.fluff.org ([89.16.178.74]:58965 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab0EFDud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 23:50:33 -0400
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, akpm@linux-foundation.org, gregkh@suse.de,
       ext-jani.1.nikula@nokia.com, ak@linux.intel.com,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] gpiolib: make gpiochip_add() show a better error message
Date: Thu,  6 May 2010 04:50:26 +0100
Message-Id: <1273117826-24615-1-git-send-email-ben-linux@fluff.org>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current message, 'not registered' is confusing as it implies it was
not registered with something, whereas printing 'failed to register' implies
it was the gpiochip_add() call that did not work correctly.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/gpio/gpiolib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index eb0c3fe..384d993 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1106,7 +1106,7 @@ unlock:
 fail:
 	/* failures here can mean systems won't boot... */
 	if (status)
-		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
+		pr_err("gpiochip_add: gpios %d..%d (%s) failed to register\n",
 			chip->base, chip->base + chip->ngpio - 1,
 			chip->label ? : "generic");
 	return status;
-- 
1.6.3.3

