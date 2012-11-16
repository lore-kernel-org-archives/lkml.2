Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2KPG53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:57:29 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:38824 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2KPG51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:27 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 09/14] xen: events: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 12:20:41 +0530
Message-Id: <1353048646-10935-10-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check whether unsigned variable is less than 0.

CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: xen-devel@lists.xensource.com
CC: virtualization@lists.linux-foundation.org
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4293c57..cadd7d1 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -216,7 +216,7 @@ static void xen_irq_info_pirq_init(unsigned irq,
  */
 static unsigned int evtchn_from_irq(unsigned irq)
 {
-	if (unlikely(WARN(irq < 0 || irq >= nr_irqs, "Invalid irq %d!\n", irq)))
+	if (unlikely(WARN(irq >= nr_irqs, "Invalid irq %d!\n", irq)))
 		return 0;
 
 	return info_for_irq(irq)->evtchn;
-- 
1.7.4.1

