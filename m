Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab1BROTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:19:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59301 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab1BROTG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 18 Feb 2011 09:19:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano.Stabellini@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/irq: Cleanup up the pirq_to_irq for DomU PV PCI passthrough guests as well.
Date: Fri, 18 Feb 2011 09:18:44 -0500
Message-Id: <1298038724-8663-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298038724-8663-1-git-send-email-konrad.wilk@oracle.com>
References: <1298038724-8663-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D5E7FD2.0058:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only did this for PV guests that are xen_initial_domain() but
there is not reason not to do this for other cases. The other
case is only exercised when you pass in a PCI device to a PV guest
_and_ the device in question.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
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
-- 
1.7.1

