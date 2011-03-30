Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965118Ab1C3V3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:29:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:33747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626Ab1C3VJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238327"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: andreas.herrmann3@amd.com, f3d27b@gmail.com, ak@linux.intel.com,
        akpm@linux-foundation.org, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [197/275] x86, quirk: Fix SB600 revision check
Message-Id: <20110330210721.24C9C3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 1d3e09a304e6c4e004ca06356578b171e8735d3c upstream.

Commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
(x86 quirk: Fix polarity for IRQ0 pin2 override on SB800
systems) introduced a regression. It removed some SB600 specific
code to determine the revision ID without adapting a
corresponding revision ID check for SB600.

See this mail thread:

  http://marc.info/?l=linux-kernel&m=129980296006380&w=2

This patch adapts the corresponding check to cover all SB600
revisions.

Tested-by: Wang Lei <f3d27b@gmail.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110315143137.GD29499@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/early-quirks.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/early-quirks.c	2011-03-29 23:03:01.447263137 -0700
+++ linux-2.6.35.y/arch/x86/kernel/early-quirks.c	2011-03-29 23:03:02.000000000 -0700
@@ -161,7 +161,12 @@
 	if (rev >= 0x40)
 		acpi_fix_pin2_polarity = 1;
 
-	if (rev > 0x13)
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
 	if (acpi_use_timer_override)
