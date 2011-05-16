Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1EPIJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:09:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54320 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab1EPIJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:09:03 -0400
Date: Mon, 16 May 2011 10:08:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, gorcunov@openvz.org
Subject: Re: [patch 1/5] x84_64, apic: Use probe routines to simplify apic
 selection
Message-ID: <20110516080844.GC27635@elte.hu>
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com>
 <20110513181008.859892593@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513181008.859892593@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x84_64, apic: Use probe routines to simplify apic selection
> 
> Use the unused probe routine in the apic driver to finalize the apic model
> selection. This cleans up the default_setup_apic_routing() and this probe
> routine in future can also be used for doing any apic model specific
> initialization.
> 
> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/kernel/apic/apic_flat_64.c   |   10 +++++++++-
>  arch/x86/kernel/apic/probe_64.c       |   22 +++++++---------------
>  arch/x86/kernel/apic/x2apic_cluster.c |    7 ++++++-
>  arch/x86/kernel/apic/x2apic_phys.c    |   10 +++++++++-
>  arch/x86/kernel/apic/x2apic_uv_x.c    |    7 ++++++-
>  5 files changed, 37 insertions(+), 19 deletions(-)

Ok, looks like a step forward in the right direction.

Wouldnt it be more self-contained if the probe function returned an apic driver 
pointer?

We could add an __apicdriver section trick to 'know' about all APIC probing 
functions - and we'd call them one by one and use the first one that returns a 
non-NULL result.

Then we'd have the generic fallback APIC drivers as well - not marked 
__apicdriver but used by the probe function directly.

Or we could have them as __apicdriver as well, but then the .o link ordering 
matters to probing order.

Thanks,

	Ingo
