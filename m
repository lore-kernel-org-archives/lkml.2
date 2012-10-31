Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab2JaDj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 23:39:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:26441 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2JaDj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 23:39:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,684,1344236400"; 
   d="scan'208";a="234940400"
From: "Zhang, Jun" <jun.zhang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
Thread-Topic: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
Thread-Index: AQHNtxIV3hnkP6jR4UukoqugoUWbs5fSwL/g
Date: Wed, 31 Oct 2012 03:39:21 +0000
Message-ID: <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com>
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com>
 <50909120.3040101@zytor.com>
In-Reply-To: <50909120.3040101@zytor.com>
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

Hello, Anvin
Thanks!

Hello, all
Next is my the latest version, please review it. 
Thanks!

>From 141546c77ff7be523a9e72f5259df4a6827f2c1a Mon Sep 17 00:00:00 2001
From: jzha144 <jun.zhang@intel.com>
Date: Wed, 31 Oct 2012 08:51:18 +0800
Subject: [PATCH] If we are doing a crash dump, we still need non-E820_RAM
 memory type address information, which come from BIOS or
 firmware. for example: PCI_MMCONFIG check this address.

Signed-off-by: jzha144 <jun.zhang@intel.com>
---
 arch/x86/kernel/e820.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index df06ade..f8672d0 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -851,6 +851,15 @@ static int __init parse_memmap_opt(char *p)
 		 * reset.
 		 */
 		saved_max_pfn = e820_end_of_ram_pfn();
+
+		/*
+		 * If we are doing a crash dump, we still need non-E820_RAM
+		 * memory type address information. so we only remove
+		 * E820_RAM type.
+		 */
+		e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);
+		userdef = 1;
+		return 0;
 #endif
 		e820.nr_map = 0;
 		userdef = 1;
-- 
1.7.6


Best Regards!

Jun Zhang
Inet: 8821-4273
Dir.Tel: 86-21-6116-4273
Email: jun.zhang@intel.com


-----Original Message-----
From: H. Peter Anvin [mailto:hpa@zytor.com] 
Sent: Wednesday, October 31, 2012 10:47 AM
To: Zhang, Jun
Cc: Thomas Gleixner; Ingo Molnar; x86@kernel.org; Andrew Morton; Fleming, Matt; Paul Gortmaker; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] To crash dump, we need keep other memory type except E820_RAM, because other type come from BIOS or firmware is used by other code(for example: PCI_MMCONFIG).

On 10/30/2012 06:26 PM, Zhang, Jun wrote:
> From aebc336baa7ec2d4ccb6f21166770c7d2ee26cba Mon Sep 17 00:00:00 2001
> From: jzha144 <jun.zhang@intel.com>
> Date: Wed, 31 Oct 2012 08:51:18 +0800
> Subject: [PATCH] To crash dump, we need keep other memory type except  
> E820_RAM, because other type come from BIOS or firmware is  used by 
> other code(for example: PCI_MMCONFIG).

I'm sorry, I can't quite parse the description or the comment... could you clarify it a bit?  I think I know what you mean, but there is clearly risk for misunderstandings.

	-hpa

