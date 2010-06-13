Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0FMPc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:32:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:37770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab0FMPcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:19 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/12] usb: use IRQ watching
Date: Sun, 13 Jun 2010 17:31:38 +0200
Message-Id: <1276443098-20653-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ask IRQ subsystem to watch HCD IRQ line after initialization.  This at
least keeps USB ports which are occupied on initialization working and
eases bug reporting and debugging.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/usb/core/hcd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 12742f1..383875f 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2270,6 +2270,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 					"request interrupt %d failed\n", irqnum);
 			goto err_request_irq;
 		}
+		watch_irq(irqnum, hcd);
 		hcd->irq = irqnum;
 		dev_info(hcd->self.controller, "irq %d, %s 0x%08llx\n", irqnum,
 				(hcd->driver->flags & HCD_MEMORY) ?
-- 
1.6.4.2

