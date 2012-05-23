Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab2EWRyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:54:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46170 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760533Ab2EWRxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:53:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH 2/4] xen/hvc: Fix error cases around HVM_PARAM_CONSOLE_PFN
Date: Wed, 23 May 2012 13:47:00 -0400
Message-Id: <1337795222-29946-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We weren't resetting the parameter to be passed in to a
known default. Nor were we checking the return value of
hvm_get_parameter.

CC: stable@kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index afc7fc2..3277f0e 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -219,7 +219,8 @@ static int xen_hvm_console_init(void)
 	if (r < 0)
 		goto err;
 	info->evtchn = v;
-	hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
+	v = 0;
+	r = hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
 	if (r < 0)
 		goto err;
 	mfn = v;
-- 
1.7.7.5

