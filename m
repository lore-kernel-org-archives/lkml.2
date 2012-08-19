Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2HSDAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:52526 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2HSC50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422067"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, benh@kernel.crashing.org,
        hpa@zytor.com
Subject: [PATCH 42/74] lto, raid: disable LTO for the Altivec RAID code
Date: Sat, 18 Aug 2012 19:56:38 -0700
Message-Id: <1345345030-22211-43-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

It needs special options for a file, which LTO does not support.

XXX: may need some more __visibles

Cc: benh@kernel.crashing.org
Cc: hpa@zytor.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 lib/raid6/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index de06dfe..55fbafb 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -10,7 +10,7 @@ quiet_cmd_unroll = UNROLL  $@
                    < $< > $@ || ( rm -f $@ && exit 1 )
 
 ifeq ($(CONFIG_ALTIVEC),y)
-altivec_flags := -maltivec -mabi=altivec
+altivec_flags := -maltivec -mabi=altivec ${DISABLE_LTO}
 endif
 
 targets += int1.c
-- 
1.7.7.6

