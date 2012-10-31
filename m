Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965186Ab2JaB0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:26:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:21031 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab2JaB0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:26:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,683,1344236400"; 
   d="scan'208,223";a="162657201"
From: "Zhang, Jun" <jun.zhang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Zhang, Jun" <jun.zhang@intel.com>
Subject: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
Thread-Topic: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
Thread-Index: Ac23BrhkFa+d0QQyRK2qvGnFwxZ/4g==
Date: Wed, 31 Oct 2012 01:26:16 +0000
Message-ID: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From aebc336baa7ec2d4ccb6f21166770c7d2ee26cba Mon Sep 17 00:00:00 2001
From: jzha144 <jun.zhang@intel.com>
Date: Wed, 31 Oct 2012 08:51:18 +0800
Subject: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is
 used by other code(for example: PCI_MMCONFIG).

Signed-off-by: jzha144 <jun.zhang@intel.com>
---
 arch/x86/kernel/e820.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index df06ade..8760427 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -851,6 +851,15 @@ static int __init parse_memmap_opt(char *p)
 		 * reset.
 		 */
 		saved_max_pfn = e820_end_of_ram_pfn();
+
+		/*
+		 * To CRASH DUMP, only remove E820_RAM.
+		 *  some other memory typecome from BIOS or firmware,
+		 * it must be same with system kernel.
+		 */
+		e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);
+		userdef = 1;
+		return 0;
 #endif
 		e820.nr_map = 0;
 		userdef = 1;
-- 
1.7.6

