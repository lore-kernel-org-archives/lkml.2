Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab2HVQVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:21:43 -0400
Received: from smtp.citrix.com ([66.165.176.89]:35720 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab2HVQUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:20:31 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336363200"; 
   d="scan'208";a="35465043"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 5/6] xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
Date: Wed, 22 Aug 2012 17:20:15 +0100
Message-ID: <1345652416-27181-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
irq_startup, that is responsible for calling irq_unmask at startup time.
As a result event channels remain masked.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 36bf17d..c60d162 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -842,6 +842,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 		struct irq_info *info = info_for_irq(irq);
 		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
 	}
+	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
 
 out:
 	mutex_unlock(&irq_mapping_update_lock);
-- 
1.7.2.5

