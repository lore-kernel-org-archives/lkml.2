Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0ERKbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:31:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:41982 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab0ERK3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:29:36 -0400
X-IronPort-AV: E=Sophos;i="4.53,254,1272859200"; 
   d="scan'208";a="97477212"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 10/12] __setup_vector_irq: handle NULL chip_data
Date: Tue, 18 May 2010 11:23:05 +0100
Message-Id: <1274178187-20602-10-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
X-OriginalArrivalTime: 18 May 2010 10:20:11.0544 (UTC) FILETIME=[B2D4C180:01CAF673]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c64499c..4d3d391 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1269,6 +1269,8 @@ void __setup_vector_irq(int cpu)
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
 		cfg = desc->chip_data;
+		if (!cfg)
+			continue;
 
 		/*
 		 * If it is a legacy IRQ handled by the legacy PIC, this cpu
-- 
1.5.4.3

