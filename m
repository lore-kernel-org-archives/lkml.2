Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1BPRxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:53:37 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34623 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1BPRxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:53:25 -0500
X-IronPort-AV: E=Sophos;i="4.60,480,1291611600"; 
   d="scan'208";a="136190336"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 7/7] xen: fix compile issue if XEN is enabled but XEN_PVHVM is disabled
Date: Wed, 16 Feb 2011 17:53:07 +0000
Message-Id: <1297878787-378-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
References: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
X-OriginalArrivalTime: 16 Feb 2011 17:53:24.0323 (UTC) FILETIME=[682D0B30:01CBCE02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/suspend.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 9bbd63a..4a3d3dd 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -28,6 +28,7 @@ void xen_pre_suspend(void)
 
 void xen_hvm_post_suspend(int suspend_cancelled)
 {
+#ifdef CONFIG_XEN_PVHVM
 	int cpu;
 	xen_hvm_init_shared_info();
 	xen_callback_vector();
@@ -37,6 +38,7 @@ void xen_hvm_post_suspend(int suspend_cancelled)
 			xen_setup_runstate_info(cpu);
 		}
 	}
+#endif
 }
 
 void xen_post_suspend(int suspend_cancelled)
-- 
1.5.6.5

