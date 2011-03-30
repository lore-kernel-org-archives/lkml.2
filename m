Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab1C3TQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:16:04 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:38628 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932769Ab1C3TQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:16:02 -0400
Date: Wed, 30 Mar 2011 21:14:26 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xen: events: fix error checks in bind_*_to_irqhandler()
Message-ID: <20110330211426.13f182d6@absol.kitzblitz>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking 'irq < 0' doesn't work when 'irq' is unsigned.

The assigned bind_evtchn_to_irq() and bind_virq_to_irq()
return int, so using int appears appropriate.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/xen/events.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 036343b..589f0a5 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -912,8 +912,7 @@ int bind_evtchn_to_irqhandler(unsigned int evtchn,
 			      unsigned long irqflags,
 			      const char *devname, void *dev_id)
 {
-	unsigned int irq;
-	int retval;
+	int irq, retval;
 
 	irq = bind_evtchn_to_irq(evtchn);
 	if (irq < 0)
@@ -955,8 +954,7 @@ int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
 			    irq_handler_t handler,
 			    unsigned long irqflags, const char *devname, void *dev_id)
 {
-	unsigned int irq;
-	int retval;
+	int irq, retval;
 
 	irq = bind_virq_to_irq(virq, cpu);
 	if (irq < 0)
-- 
1.7.3.4
