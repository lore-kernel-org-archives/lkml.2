Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab2IYVuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:50:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:2419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab2IYVuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:50:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,485,1344236400"; 
   d="scan'208";a="212968645"
Subject: [PATCH 0/3] Optimize CRC32C calculation using PCLMULQDQ in
 crc32c-intel module
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>,
        James Guilford <james.guilford@intel.com>,
        David Cote <david.m.cote@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Chaohong Guo <chaohong.guo@intel.com>,
        Austin Zhang <austin_zhang@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
References: <cover.1348599489.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Sep 2012 14:50:08 -0700
Message-ID: <1348609808.9977.205.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series optimized CRC32C calculations with PCLMULQDQ
instruction for crc32c-intel module.  It speeds up the original
implementation by 1.6x for 1K buffer and by 3x for buffer 4k or
more.  The tcrypt module was enhanced for doing speed test
on crc32c calculations.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
Tim Chen (3):
  Rename crc32c-intel.c to crc32c-intel_glue.c
  Optimize CRC32C calculation with PCLMULQDQ instruction
  Added speed test in tcrypt for crc32c

 arch/x86/crypto/Makefile                           |    1 +
 .../crypto/{crc32c-intel.c => crc32c-intel_glue.c} |   75 ++++
 arch/x86/crypto/crc32c-pcl-intel-asm.S             |  460 ++++++++++++++++++++
 crypto/tcrypt.c                                    |    4 +
 4 files changed, 540 insertions(+), 0 deletions(-)
 rename arch/x86/crypto/{crc32c-intel.c => crc32c-intel_glue.c} (70%)
 create mode 100644 arch/x86/crypto/crc32c-pcl-intel-asm.S

-- 
1.7.7.6


