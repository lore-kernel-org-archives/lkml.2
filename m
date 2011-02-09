Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1BITDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:03:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:58318 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab1BITDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:03:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,446,1291622400"; 
   d="scan'208";a="705879244"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Huang, Ying" <ying.huang@intel.com>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 9 Feb 2011 11:03:35 -0800
Subject: RE: [RFC 1/2] lib, Make gen_pool memory allocator lockless
Thread-Topic: [RFC 1/2] lib, Make gen_pool memory allocator lockless
Thread-Index: AcvIKtfzYVYqc/GmRym1iExBze8u8gAYIXQg
Message-ID: <987664A83D2D224EAE907B061CE93D53019D18D43A@orsmsx505.amr.corp.intel.com>
References: <1297236451-11331-1-git-send-email-ying.huang@intel.com>
 <1297236451-11331-2-git-send-email-ying.huang@intel.com>
In-Reply-To: <1297236451-11331-2-git-send-email-ying.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
+{
+	unsigned long val, nval;
+
+	nval = *addr;
+	do {
+		val = nval;
+		if (val & mask_to_set)
+			return -EBUSY;
+	} while ((nval = cmpxchg(addr, val, val | mask_to_set)) != val);
+
+	return 0;
+}

Spin loops like this should have a call to cpu_relax(), shouldn't they?

-Tony
