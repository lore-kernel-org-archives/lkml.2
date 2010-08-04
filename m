Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0HDSUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:20:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54446 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0HDSUS (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com, Gerd Hoffmann <kraxel@xeni.home.kraxel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 07/20] xen: set pirq name to something useful.
Date: Wed,  4 Aug 2010 14:19:02 -0400
Message-Id: <1280945955-14229-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C59AF55.01C8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>

Impact: cleanup

Make pirq show useful information in /proc/interrupts

[v2: Removed the parts for arch/x86/xen/pci.c ]

Signed-off-by: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    4 ++--
 include/xen/events.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ac04ded..64cde24 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -531,7 +531,7 @@ static int find_irq_by_gsi(unsigned gsi)
  * event channel until the irq actually started up.  Return an
  * existing irq if we've already got one for the gsi.
  */
-int xen_allocate_pirq(unsigned gsi)
+int xen_allocate_pirq(unsigned gsi, char *name)
 {
 	int irq;
 	struct physdev_irq irq_op;
@@ -553,7 +553,7 @@ int xen_allocate_pirq(unsigned gsi)
 		irq = find_unbound_irq();
 
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
-				      handle_level_irq, "pirq");
+				      handle_level_irq, name);
 
 	irq_op.irq = irq;
 	if (HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
diff --git a/include/xen/events.h b/include/xen/events.h
index 2303180..e8f5b81 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -59,7 +59,7 @@ unsigned irq_from_evtchn(unsigned int evtchn);
 /* Allocate an irq for a physical interrupt, given a gsi.  "Legacy"
    GSIs are identity mapped; others are dynamically allocated as
    usual. */
-int xen_allocate_pirq(unsigned gsi);
+int xen_allocate_pirq(unsigned gsi, char *name);
 
 /* Return vector allocated to pirq */
 int xen_vector_from_irq(unsigned pirq);
-- 
1.7.0.1

