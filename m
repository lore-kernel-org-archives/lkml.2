Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab2IYVu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:50:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:26095 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2IYVuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:50:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,485,1344236400"; 
   d="scan'208";a="212968824"
Subject: [PATCH 3/3] Added speed test in tcrypt for crc32c
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        David Cote <david.m.cote@intel.com>,
        Austin Zhang <austin_zhang@linux.intel.com>,
        Chaohong Guo <chaohong.guo@intel.com>
In-Reply-To: <cover.1348599489.git.tim.c.chen@linux.intel.com>
References: <cover.1348599489.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Sep 2012 14:50:18 -0700
Message-ID: <1348609818.9977.208.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a test case in tcrypt to perform speed test for
crc32c checksum calculation.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/tcrypt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 581081d..6deb77f 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1437,6 +1437,10 @@ static int do_test(int m)
 		test_hash_speed("ghash-generic", sec, hash_speed_template_16);
 		if (mode > 300 && mode < 400) break;
 
+	case 319:
+		test_hash_speed("crc32c", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
-- 
1.7.7.6


