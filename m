Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab1BROTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:19:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59270 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab1BROTG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 18 Feb 2011 09:19:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano.Stabellini@eu.citrix.com
Subject: [PATCH] 2.6.39 patch for Xen IRQ rework.
Date: Fri, 18 Feb 2011 09:18:43 -0500
Message-Id: <1298038724-8663-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D5E7FD1.01B7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is one single patch that I spotted while trying to make MSI/MSI-X of SR-IOV
devices work under DomU PV guests.


Konrad Rzeszutek Wilk (1):
      xen/irq: Cleanup up the pirq_to_irq for DomU PV PCI passthrough guests as well.

 drivers/xen/events.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 975e90f..89987a7 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -766,8 +766,9 @@ int xen_destroy_irq(int irq)
 			printk(KERN_WARNING "unmap irq failed %d\n", rc);
 			goto out;
 		}
-		pirq_to_irq[info->u.pirq.pirq] = -1;
 	}
+	pirq_to_irq[info->u.pirq.pirq] = -1;
+
 	irq_info[irq] = mk_unbound_info();
 
 	xen_free_irq(irq);
