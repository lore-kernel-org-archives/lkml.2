Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab2FDFll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:41:41 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54747 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab2FDFkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:40 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 13/15] tools/power turbostat: fix IVB support
Date: Mon,  4 Jun 2012 01:40:04 -0400
Message-Id: <650a37f32d2bc16fa802075be579802bc4ec4132.1338786832.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
In-Reply-To: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
References: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Initial IVB support went into turbostat in Linux-3.1:
553575f1ae048aa44682b46b3c51929a0b3ad337
(tools turbostat: recognize and run properly on IVB)

However, when running on IVB, turbostat would fail
to report the new couters added with SNB, c7, pc2 and pc7.
So in scenarios where these counters are non-zero on IVB,
turbostat would report erroneous residencey results.

In particular c7 time would be added to c1 time,
since c1 time is calculated as "that which is left over".

Also, turbostat reports MHz capabilities when passed
the "-v" option, and it would incorrectly report 133MHz
bclk instead of 100MHz bclk for IVB, which would inflate
GHz reported with that option.

This patch is a backport of a fix already included in turbostat v2.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index d5d6a3d..16de7ad 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -933,6 +933,8 @@ int is_snb(unsigned int family, unsigned int model)
 	switch (model) {
 	case 0x2A:
 	case 0x2D:
+	case 0x3A:	/* IVB */
+	case 0x3D:	/* IVB Xeon */
 		return 1;
 	}
 	return 0;
-- 
1.7.11.rc0.100.g5498c5f

