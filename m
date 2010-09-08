Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0IHVEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:04:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63164 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0IHVEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:04:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sUeOw+ikST616aTLBhg/ctrWszh6wolA8xzlTCWlWmlBULVIIdrB+fdT1yU3HRELUk
         YswhBg/VHvlTAnSzizJqvb4zFoJiIkxPXviRQLgyBA6CWeYCJPWwgF2AKbuISxRpo+tB
         3aIjuGlxwGYQXcjReDgpJclaZh34kIr9F3SMI=
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: tony.luck@intel.com, fenghua.yu@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikitas Angelinas <nikitasangelinas@gmail.com>
Subject: [PATCH 1/8] arch/ia64/xen: use ARRAY_SIZE macro in xen_pv_ops.c
Date: Wed,  8 Sep 2010 22:04:30 +0100
Message-Id: <1283979870-4764-1-git-send-email-nikitasangelinas@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sizeof(xen_branch_target) / sizeof(xen_branch_target[0]) with
ARRAY_SIZE(xen_branch_target) in arch/ia64/xen/xen_pv_ops.c

Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>
---
 arch/ia64/xen/xen_pv_ops.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/xen/xen_pv_ops.c b/arch/ia64/xen/xen_pv_ops.c
index 8adc6a1..3e8d350 100644
--- a/arch/ia64/xen/xen_pv_ops.c
+++ b/arch/ia64/xen/xen_pv_ops.c
@@ -1136,7 +1136,6 @@ __initconst = {
 static void __init
 xen_patch_branch(unsigned long tag, unsigned long type)
 {
-	const unsigned long nelem =
-		sizeof(xen_branch_target) / sizeof(xen_branch_target[0]);
-	__paravirt_patch_apply_branch(tag, type, xen_branch_target, nelem);
+	__paravirt_patch_apply_branch(tag, type, xen_branch_target,
+					ARRAY_SIZE(xen_branch_target));
 }
-- 
1.7.2.3

