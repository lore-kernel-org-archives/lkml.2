Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2FUVwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:52:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:51389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848Ab2FUVww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:52:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183437397"
Subject: Re: [PATCH 1/2] x86, apic: optimize cpu traversal in
 __assign_irq_vector() using domain membership
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Date: Thu, 21 Jun 2012 14:53:18 -0700
In-Reply-To: <20120621083146.GC2223@dhcp-26-207.brq.redhat.com>
References: <1340067097.3696.6.camel@sbsiddha-desk.sc.intel.com>
	 <1340149411-2972-1-git-send-email-suresh.b.siddha@intel.com>
	 <20120621083146.GC2223@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1340315598.3696.89.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 10:31 +0200, Alexander Gordeev wrote:
> On Tue, Jun 19, 2012 at 04:43:30PM -0700, Suresh Siddha wrote:
> > Use the irq_cfg's old_domain to track the visited domains and optimize
> > the cpu traversal while finding a free vector in the given cpumask.
> > 
> > NOTE: We can also optimize the search by using for_each_cpu and skip the
> > current cpu, if it is not the first cpu in the mask returned by the
> > vector_allocation_domain(). But re-using the cfg->old_domain to track
> > the visited domains will be slightly faster.
> 
> Sorry for the dealy, Suresh.
> 
> You also need to kick out vector_allocation_domain's return value in all other
> apic drivers.

this patch is on top of -tip which already has your patch which
consolidates different vector_allocation_domains to relatively few. I
double checked and don't seem to left out any other apic driver.

thanks,
suresh


