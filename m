Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585Ab2FUV6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:58:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:3944 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760452Ab2FUV6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:58:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="160939643"
Subject: Re: [PATCH 1/2] x86, irq: update irq_cfg domain unless the new
 affinity is a subset of the current domain
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Ingo Molnar <mingo@kernel.org>
Date: Thu, 21 Jun 2012 14:58:59 -0700
In-Reply-To: <20120621110055.GE2223@dhcp-26-207.brq.redhat.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
	 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <20120606172017.GA4777@dhcp-26-207.brq.redhat.com>
	 <1339806320.3475.68.camel@sbsiddha-desk.sc.intel.com>
	 <20120618091740.GK3383@dhcp-26-207.brq.redhat.com>
	 <1340151523.3696.27.camel@sbsiddha-desk.sc.intel.com>
	 <20120621110055.GE2223@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1340315939.3696.95.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 13:00 +0200, Alexander Gordeev wrote:
> On Tue, Jun 19, 2012 at 05:18:42PM -0700, Suresh Siddha wrote:
> > On Mon, 2012-06-18 at 17:51 -0700, Suresh Siddha wrote:
> > BTW, there is still one open that I would like to address. How to handle
> > the vector pressure during boot etc (as the default vector assignment
> > specifies all online cpus) when there are lot interrupt sources but
> > fewer x2apic clusters (like one or two socket server case).
> > 
> > We should be able to do something like the appended. Any better
> > suggestions? I don't want to add boot parameters to limit the x2apic
> > cluster membership etc (to fewer than 16 logical cpu's) if possible.
> 
> This cpu_online_mask approach should work IMO. Although it looks little bit
> hacky for me. May be we could start with default_vector_allocation_domain()
> and explicitly switch to cluster_vector_allocation_domain() once booted?

It is not just during boot. Module load/unload will also go through
these paths.

> As of boot parameters, I can think of multi-pass walk thru a cpumask to find a
> free cluster => core => sibling. In worst case I can imagine a vector space
> defragmentator. But nothing really small to avoid current code reshake.

We can probably go with something simple as I sent earlier (third patch
in the new version does this). Depending on the need/future use-cases,
we can further enhance this later.

> Also, how heavy the vector pressure actually is?

I don't know. but I suspect one socket server where they can be one
x2apic cluster (for example 8-core with HT), will see some pressure on
some platforms.

thanks,
suresh

