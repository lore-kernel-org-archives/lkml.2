Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab2I0WoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:44:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:8931 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341Ab2I0WoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:44:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="214740674"
Subject: [PATCH 1/3 v2] Rename crc32c-intel.c to crc32c-intel_glue.c
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Chaohong Guo <chaohong.guo@intel.com>,
        Austin Zhang <austin_zhang@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>, Min Li <min.a.li@intel.com>,
        David Cote <david.m.cote@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
In-Reply-To: <cover.1348784343.git.tim.c.chen@linux.intel.com>
References: <cover.1348784343.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 15:44:17 -0700
Message-ID: <1348785857.17632.16.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the crc32c-intel.c file to crc32c-intel_glue.c file
in preparation for linking with the new crc32c-pcl-intel-asm.S file,
which contains optimized crc32c calculation based on PCLMULQDQ
instruction.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/Makefile                           |    1 +
 .../crypto/{crc32c-intel.c => crc32c-intel_glue.c} |    0
 2 files changed, 1 insertions(+), 0 deletions(-)
 rename arch/x86/crypto/{crc32c-intel.c => crc32c-intel_glue.c} (100%)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e908e5d..edd2268 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -43,3 +43,4 @@ serpent-avx-x86_64-y := serpent-avx-x86_64-asm_64.o serpent_avx_glue.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
+crc32c-intel-y := crc32c-intel_glue.o
diff --git a/arch/x86/crypto/crc32c-intel.c b/arch/x86/crypto/crc32c-intel_glue.c
similarity index 100%
rename from arch/x86/crypto/crc32c-intel.c
rename to arch/x86/crypto/crc32c-intel_glue.c
-- 
1.7.7.6



