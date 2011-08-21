Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1HUTKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 15:10:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab1HUTKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 15:10:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-sh@vger.kernel.org
Subject: [PATCH 2/2 v2] sh-sci / PM: Use power.irq_safe
Date: Sun, 21 Aug 2011 21:11:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201108202131.19479.rjw@sisk.pl> <201108212109.30399.rjw@sisk.pl>
In-Reply-To: <201108212109.30399.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108212111.45012.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since sci_port_enable() and sci_port_disable() may be run with
interrupts off and they execute pm_runtime_get_sync() and
pm_runtime_put_sync(), respectively, the SCI device's
power.irq_safe flags has to be used to indicate that it is safe
to execute runtime PM callbacks for this device with interrupts off.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/tty/serial/sh-sci.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/tty/serial/sh-sci.c
===================================================================
--- linux.orig/drivers/tty/serial/sh-sci.c
+++ linux/drivers/tty/serial/sh-sci.c
@@ -1913,6 +1913,7 @@ static int __devinit sci_init_single(str
 
 		port->dev = &dev->dev;
 
+		pm_runtime_irq_safe(&dev->dev);
 		pm_runtime_enable(&dev->dev);
 	}
 

