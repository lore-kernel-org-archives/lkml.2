Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0H0ILk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:11:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab0H0ILh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:11:37 -0400
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100827075737.GE22783@erda.amd.com>
References: <20100825094819.GB3198@erda.amd.com>
	 <20100825104130.GA27891@elte.hu> <20100825110006.GB27891@elte.hu>
	 <20100825201106.GH4879@redhat.com> <20100826090008.GA22783@erda.amd.com>
	 <AANLkTim3+u-fV-RAC=Odede6BfGdYoXsN55Tqw6iSfVT@mail.gmail.com>
	 <20100826152246.GN4879@redhat.com> <20100826153404.GA6306@lenovo>
	 <20100826164031.GO4879@redhat.com> <20100826180250.GB6306@lenovo>
	 <20100827075737.GE22783@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 10:11:21 +0200
Message-ID: <1282896681.1975.1760.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 09:57 +0200, Robert Richter wrote:
> On 26.08.10 14:02:50, Cyrill Gorcunov wrote:
> > > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> > > index 4539b4b..9e65a7b 100644
> > > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > > @@ -777,7 +777,9 @@ again:
> > >  
> > >  done:
> > >  	intel_pmu_enable_all(0);
> > > -	return handled;
> > > +	if (!handled)
> > > +		return handled;
> > > +	return ++handled;
> > >  }
> > >  
> > >  static struct event_constraint *
> > > 
> > 
> > ok, it seems it just treat any unknown nmi as being came from PMU, no?
> 
> Yes, this just throws away all unknown nmis after a perf nmi. It
> disables unknown nmi detection on this cpu type.

Wouldn't returning 2 be more sensible, then it would only eat a few
unknowns after each pmi? (Still assuming you return 0 when there really
was nothing to do)
