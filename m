Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab1EFShj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:37:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:28073 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab1EFShh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:37:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,327,1301900400"; 
   d="scan'208";a="689224050"
Subject: Re: [PATCH -v2 RESENDING] x86, acpi: Handle xapic/x2apic entries
 in MADT at same time
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <4DC0514F.9070901@kernel.org>
References: <4DA41476.8040700@jp.fujitsu.com>
	 <1304379923.19493.284.camel@sbsiddha-MOBL3.sc.intel.com>
	 <4DC0514F.9070901@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 06 May 2011 11:38:04 -0700
Message-Id: <1304707084.2736.8.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 12:02 -0700, Yinghai Lu wrote:
> One system have mixing xapic and x2apic entries in MADT and SRAT.
> BIOS guys insist that ACPI 4.0 SPEC said so, if apic id < 255, even
> the cpus are with x2apic mode pre-enabled, still need to use xapic entries
> instead of x2apic entries.
> 
> on 8 socket system with x2apic pre-enabled, will get out of order sequence:
> CPU0: socket0, core0, thread0.
> CPU1 - CPU 40: socket 4 - socket 7, thread 0
> CPU41 - CPU 80: socket 4 - socket 7, thread 1
> CPU81 - CPU 119: socket 0 - socket 3, thread 0
> CPU120 - CPU 159: socket 0 - socket 3, thread 1
> 
> so max_cpus=80 will not get all thread0 now.
> 
> Need to handle every entry in MADT at same time with xapic and x2apic.
> so we can honor sequence in MADT.
> 
> We can use max_cpus= command line to use thread0 in every core,
> because recent MADT always have all thread0 at first.
> Also it could make the cpu to node mapping more sane.
> 
> after patch will get
> CPU0 - CPU 79: socket 0 - socket 7, thread 0
> CPU80 - CPU 159: socket 0 - socket 7, thread 1
> 
> -v2: update some comments, and change to pass array pointer.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/acpi/boot.c |   30 ++++++++++++++++-------
>  drivers/acpi/numa.c         |   16 +++++++++---
>  drivers/acpi/tables.c       |   57 +++++++++++++++++++++++++++++++++-----------
>  include/linux/acpi.h        |    9 ++++++
>  4 files changed, 86 insertions(+), 26 deletions(-)

Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>

Len, If you are ok, then can you please queue this up?

thanks,
suresh

