Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0IQWMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:12:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:52345 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab0IQWMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:12:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,384,1280732400"; 
   d="scan'208";a="555621810"
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20100914111954.GB2201@osiris.boeblingen.de.ibm.com>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
	 <1284116817.402.33.camel@laptop>
	 <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
	 <1284196838.2251.12.camel@laptop>
	 <AANLkTi=Vrd0g-64oRYLo6fTj1SYYa++VG57vGn608tkA@mail.gmail.com>
	 <1284400941.2684.19.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1284451427.2275.462.camel@laptop>
	 <20100914111954.GB2201@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 17 Sep 2010 15:12:33 -0700
Message-Id: <1284761553.2676.21.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 04:19 -0700, Heiko Carstens wrote:
> > 
> > So what patches are we going to merge?
> > 
> > I share Heiko's opinion on that its somewhat surprising to have
> > __smp_call_function_single() differ in this detail from
> > smp_call_function_single() and think that merging his patch would be
> > good in that respect. But Andrew seemed to have reservations.
> > 
> > We can also merge either my or Suresh's patch (which I think makes
> > sense, but is kinda subtle) to avoid the needless self kick.

Peter, Can you please merge my patch instead of yours, as mine is more
appropriate here. And also I would like Heiko's patch also to be merged
as that brings smp_call_function_single() and
__smp_call_function_single() to similar behavior.

thanks,
suresh

> 
> I would prefer to see your's or Suresh's scheduler patch to be merged to
> fix the bug.
> My patch could be merged for 2.6.37 or be dropped in favour of a WARN_ON
> in __smp_call_function_single() if remote cpu == current cpu.
> However I think it would be better if smp_call_function_single() and
> __smp_call_function_single() wouldn't differ here.

