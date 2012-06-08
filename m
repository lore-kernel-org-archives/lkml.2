Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2FHSZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:25:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:30370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab2FHSZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:25:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176990832"
Subject: Re: [PATCH] x86/apic: Eliminate cpu_mask_to_apicid() operation
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 08 Jun 2012 11:24:39 -0700
In-Reply-To: <20120608165330.GE4777@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
	 <20120606082231.GD5991@gmail.com>
	 <20120607131559.GF4759@dhcp-26-207.brq.redhat.com>
	 <1339107848.28766.104.camel@sbsiddha-desk.sc.intel.com>
	 <20120608165330.GE4777@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339179879.28766.119.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 18:53 +0200, Alexander Gordeev wrote:
> Since there are only two locations where cpu_mask_to_apicid() is called
> from, remove the operation and use only cpu_mask_to_apicid_and() instead.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/include/asm/apic.h           |   33 ++++++++-------------------------
>  arch/x86/kernel/apic/apic.c           |   24 ++++++------------------
>  arch/x86/kernel/apic/apic_flat_64.c   |    2 --
>  arch/x86/kernel/apic/apic_noop.c      |    1 -
>  arch/x86/kernel/apic/apic_numachip.c  |    1 -
>  arch/x86/kernel/apic/bigsmp_32.c      |    1 -
>  arch/x86/kernel/apic/es7000_32.c      |    4 +---
>  arch/x86/kernel/apic/io_apic.c        |    3 ++-
>  arch/x86/kernel/apic/numaq_32.c       |    8 --------
>  arch/x86/kernel/apic/probe_32.c       |    1 -
>  arch/x86/kernel/apic/summit_32.c      |    3 +--
>  arch/x86/kernel/apic/x2apic_cluster.c |   17 -----------------
>  arch/x86/kernel/apic/x2apic_phys.c    |    1 -
>  arch/x86/kernel/apic/x2apic_uv_x.c    |   29 ++++++-----------------------
>  arch/x86/platform/uv/uv_irq.c         |    2 +-
>  15 files changed, 25 insertions(+), 105 deletions(-)
> 

Looks good to me.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

