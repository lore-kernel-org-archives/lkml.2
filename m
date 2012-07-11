Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab2GKTMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:12:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40172 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2GKTLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:11:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] xen/hvc: Fix up checks when the info is allocated.
Date: Wed, 11 Jul 2012 15:03:20 -0400
Message-Id: <1342033400-22505-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342033400-22505-1-git-send-email-konrad.wilk@oracle.com>
References: <1342033400-22505-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity would complain about this - even thought it looks OK.

CID 401957
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 944eaeb..1e456dc 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -209,11 +209,10 @@ static int xen_hvm_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
 		if (!info)
 			return -ENOMEM;
-	}
-
-	/* already configured */
-	if (info->intf != NULL)
+	} else if (info->intf != NULL) {
+		/* already configured */
 		return 0;
+	}
 	/*
 	 * If the toolstack (or the hypervisor) hasn't set these values, the
 	 * default value is 0. Even though mfn = 0 and evtchn = 0 are
@@ -259,12 +258,10 @@ static int xen_pv_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
 		if (!info)
 			return -ENOMEM;
-	}
-
-	/* already configured */
-	if (info->intf != NULL)
+	} else if (info->intf != NULL) {
+		/* already configured */
 		return 0;
-
+	}
 	info->evtchn = xen_start_info->console.domU.evtchn;
 	info->intf = mfn_to_virt(xen_start_info->console.domU.mfn);
 	info->vtermno = HVC_COOKIE;
-- 
1.7.7.6

