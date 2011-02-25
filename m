Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1BYRLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:11:38 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:53802 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab1BYRLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:11:35 -0500
X-IronPort-AV: E=Sophos;i="4.62,226,1297054800"; 
   d="scan'208";a="137550370"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 6/6] xen: fix compile issue if XEN is enabled but XEN_PVHVM is disabled
Date: Fri, 25 Feb 2011 17:12:00 +0000
Message-Id: <1298653920-20299-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
References: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
X-OriginalArrivalTime: 25 Feb 2011 17:11:34.0892 (UTC) FILETIME=[0E2802C0:01CBD50F]
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

