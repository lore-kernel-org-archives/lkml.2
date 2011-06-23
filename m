Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab1FWSQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:16:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:26359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933292Ab1FWSQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:16:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,414,1304319600"; 
   d="scan'208";a="18912465"
Subject: Re: [patch 1/4] x86, mtrr: lock stop machine during MTRR
 rendezvous sequence
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "mingo@elte.hu" <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>, "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <alpine.LFD.2.02.1106231131300.11814@ionos>
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
	 <20110622222043.862589370@sbsiddha-MOBL3.sc.intel.com>
	 <1308819905.1022.70.camel@twins>
	 <alpine.LFD.2.02.1106231131300.11814@ionos>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 23 Jun 2011 11:16:40 -0700
Message-Id: <1308853000.15847.87.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 02:33 -0700, Thomas Gleixner wrote:
> On Thu, 23 Jun 2011, Peter Zijlstra wrote:
> 
> > On Wed, 2011-06-22 at 15:20 -0700, Suresh Siddha wrote:
> > > +#ifdef CONFIG_SMP
> > > +       /*
> > > +        * If we are not yet online, then there can be no stop_machine() in
> > > +        * parallel. Stop machine ensures this by using get_online_cpus().
> > > +        *
> > > +        * If we are online, then we need to prevent a stop_machine() happening
> > > +        * in parallel by taking the stop cpus mutex.
> > > +        */
> > > +       if (cpu_online(raw_smp_processor_id()))
> > > +               mutex_lock(&stop_cpus_mutex);
> > > +#endif 
> > 
> > This reads like an optimization, is it really worth-while to not take
> > the mutex in the rare offline case?
>  
> You cannot block on a mutex when you are not online, in fact you
> cannot block on it when not active, so the check is wrong anyway.
> 

Ok. Thanks for educating me on that.

Here we are neither online nor active. So we should be ok. But to be
safe, I changed the online checks to active checks and updated the above
comment also in the new revision.

thanks,
suresh

