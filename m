Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab2HFO4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:56:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57426 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2HFO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:56:04 -0400
X-IronPort-AV: E=Sophos;i="4.77,720,1336363200"; 
   d="scan'208";a="204279817"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 16/23] xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
Date: Mon, 6 Aug 2012 15:27:19 +0100
Message-ID: <1344263246-28036-16-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
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
---
 drivers/xen/events.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 5ecb596..8ffb7b7 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -836,6 +836,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 		struct irq_info *info = info_for_irq(irq);
 		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
 	}
+	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
 
 out:
 	mutex_unlock(&irq_mapping_update_lock);
-- 
1.7.2.5

