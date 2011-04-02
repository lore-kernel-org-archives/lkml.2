Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1DBGXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:23:18 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:40294 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1DBGXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:23:15 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org, stable@kernel.org
Subject: [PATCH 02/18] x86 idle floppy: deprecate disable_hlt()
Date: Sat, 02 Apr 2011 02:22:44 -0400
Message-id: <f925862949eb722b15453ab6c053d674147580d3.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Plan to remove floppy_disable_hlt in 2.6.40, an ancient
workaround with comments that it should be removed.

This allows us to remove clutter and a run-time branch
from the idle code.

WARN_ONCE() on invocation until it is removed.

cc: x86@kernel.org
cc: stable@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 drivers/block/floppy.c                     |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index b3f35e5..54db467 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,14 @@ be removed from this file.
 
 ---------------------------
 
+What:	x86 floppy disable_hlt
+When:	2.6.40
+Why:	ancient workaround of dubious utility clutters the
+	code used by everybody else.
+Who:	Len Brown <len.brown@intel.com>
+
+---------------------------
+
 What:	PRISM54
 When:	2.6.34
 
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 77fc76f..41ea03f 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1038,6 +1038,7 @@ static void floppy_disable_hlt(void)
 {
 	unsigned long flags;
 
+	WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2.6.40");
 	spin_lock_irqsave(&floppy_hlt_lock, flags);
 	if (!hlt_disabled) {
 		hlt_disabled = 1;
-- 
1.7.5.rc0

