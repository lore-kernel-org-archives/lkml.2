Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1LNCVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:21:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:18670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab1LNCVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:21:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95895298"
Subject: Re: [patch v3]numa: add a sysctl to control interleave allocation
 granularity from each node to improve I/O performance
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <20111213203856.GA6312@tassilo.jf.intel.com>
References: <1323655125.22361.376.camel@sli10-conroe>
	 <20111213190632.GA5830@tassilo.jf.intel.com>
	 <alpine.DEB.2.00.1112131412320.27186@router.home>
	 <20111213203856.GA6312@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 10:33:47 +0800
Message-ID: <1323830027.22361.401.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 04:38 +0800, Andi Kleen wrote:
> On Tue, Dec 13, 2011 at 02:12:58PM -0600, Christoph Lameter wrote:
> > On Tue, 13 Dec 2011, Andi Kleen wrote:
> > 
> > > I would prefer to add a new policy (INTERLEAVE_MULTI or so) for this
> > > instead of a global sysctl, that takes the additional parameter.
> > 
> > That would require a change of all scripts and code that uses
> > MPOL_INTERLEAVE. Lets not do that.
> 
> Yes, but setting a sysctl would need the same right?
> 
> It's not clear that all workloads want this.
> 
> With a global switch only you cannot set it case by case.
That's what I want to avoid letting each apps to explicitly do it, it's
a lot of burden.
That's true only workload with heavy I/O wants this. but I don't expect
it will harm other workloads.

>> Also I don't like having more per task state. Could you compute this
>> from the address instead even for the process policy case?
>
>That sounds good.
the process policy case doesn't give an address for allocation.

Thanks,
Shaohua

