Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1LLGPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 01:15:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:24442 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1LLGPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 01:15:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95080787"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>
Date: Mon, 12 Dec 2011 14:13:54 +0800
Subject: RE: [Regression, bisected]
 a3e06bbe8445f57eb949e6474c5a9b30f24d2057: KVM: emulate lapic tsc deadline
 timer for guest"
Thread-Topic: [Regression, bisected]
 a3e06bbe8445f57eb949e6474c5a9b30f24d2057: KVM: emulate lapic tsc deadline
 timer for guest"
Thread-Index: Acy4ZZJt+tDHCYcKScG1DhtBxj9/vwALb6Yg
Message-ID: <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com>
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com>
In-Reply-To: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com>
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

Alexey Zaytsev wrote:
> Hi.
> 
> After a recent change, qemu --enable-kvm (both 0.15.92 and 1.0) fails
> to boot illumos. The OS gets stuck pretty late in the boot process,
> without any hints from the guest. MDB (the illumos kenrnel debugger)
> failed to clarify the situation at once, the kernel seems to be stuck
> idling. I've bisected the problem to commit
> a3e06bbe8445f57eb949e6474c5a9b30f24d2057. Please let me know if you
> need me to collect any debug information or test any patches.

Alexey,

Does illumos use tsc deadline timer? and do you run it at Intel platform?

If yes, would you please help me to collect debug information by add some printk points at kvm tsc deadline timer logic? currently I totally have no clue to figure out what the issue root from :)
and, would you please check illumos tsc deadline timer logic by confirm whether illumos
1). Enumerate tsc deadline timer capability by CPUID;
2). Enable tsc deadline timer mode by lapic MMIO;
3). Start tsc deadline timer by WRMSR;

Thanks,
Jinsong