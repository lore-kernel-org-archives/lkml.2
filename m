Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1G0Amr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:42:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:6474 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab1G0Aex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:34:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="34855483"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: davej@redhat.com, sam@ravnborg.org, mmarek@suse.cz, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [1/98] kbuild: Disable -Wunused-but-set-variable for gcc 4.6.0
Message-Id: <20110727003453.01E212403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:34:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dave Jones <davej@redhat.com>

[ upstream commit af0e5d565d2fffcd97d1e2d89669d627cc04e8b8 ]

Disable the new -Wunused-but-set-variable that was added in gcc 4.6.0
It produces more false positives than useful warnings.

This can still be enabled using W=1

[AK: dropped W=1 support in backport]
Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/Makefile
===================================================================
--- linux-2.6.35.y.orig/Makefile
+++ linux-2.6.35.y/Makefile
@@ -546,6 +546,9 @@ ifndef CONFIG_CC_STACKPROTECTOR
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 endif
 
+# This warning generated too much noise in a regular build.
+KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
