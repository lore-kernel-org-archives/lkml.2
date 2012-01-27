Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2A0H0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:26:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:49127 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2A0H0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:26:30 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH 5/7] ia64, irq: add dummy create_irq_nr()
Date: Thu, 26 Jan 2012 23:25:51 -0800
Message-Id: <1327649153-16477-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
References: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F225195.00AA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_irq() will return -1 when fail to allocate.
create_irq_nr() will return 0 when fail to allocate.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/irq_ia64.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 782c3a35..07fcbdc 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -431,6 +431,16 @@ int create_irq(void)
 	return irq;
 }
 
+unsigned int create_irq_nr(unsigned int from, int node)
+{
+	int irq = create_irq();
+
+	if (irq < 0)
+		irq = 0;
+
+	return irq;
+}
+
 void destroy_irq(unsigned int irq)
 {
 	dynamic_irq_cleanup(irq);
-- 
1.7.7

