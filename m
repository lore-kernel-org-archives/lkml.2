Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1LLR2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:28:41 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42158
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753564Ab1LLR2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:28:33 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 3/4] Drivers: hv: Get rid of an unnecessary check in hv.c
Date: Mon, 12 Dec 2011 09:29:18 -0800
Message-Id: <1323710959-29655-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1323710959-29655-1-git-send-email-kys@microsoft.com>
References: <1323710931-29616-1-git-send-email-kys@microsoft.com>
 <1323710959-29655-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for eventually supporting kexec in Linux VMs on Hyper-V,
get rid of an unnecessary check in hv_init().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index f8a77d0..12aa97f 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -164,11 +164,6 @@ int hv_init(void)
 
 	max_leaf = query_hypervisor_info();
 
-	rdmsrl(HV_X64_MSR_GUEST_OS_ID, hv_context.guestid);
-
-	if (hv_context.guestid != 0)
-		goto cleanup;
-
 	/* Write our OS info */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, HV_LINUX_GUEST_ID);
 	hv_context.guestid = HV_LINUX_GUEST_ID;
-- 
1.7.4.1

