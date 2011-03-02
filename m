Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1CBKce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:32:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44348 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab1CBKcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:32:32 -0500
Subject: Re: [PATCH v2 1/4] perf-events: Add support for supplementary
 event registers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=a3_EE8RwdRTmhpcgGwq2fY8jXMC=s+zwh7_NE@mail.gmail.com>
References: <1298998076.2170.62.camel@localhost>
	 <AANLkTimvx+MYhOw8VFsJn4V6FQutKiYO6pHxgd9xGY8A@mail.gmail.com>
	 <1299026246.4937.99.camel@minggr.sh.intel.com>
	 <AANLkTi=a3_EE8RwdRTmhpcgGwq2fY8jXMC=s+zwh7_NE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 11:34:01 +0100
Message-ID: <1299062041.1310.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 08:48 +0100, Stephane Eranian wrote:
> >> >        __u32                   bp_type;
> >> > -       __u64                   bp_addr;
> >> > -       __u64                   bp_len;
> >> > +       union {
> >> > +               __u64           bp_addr;
> >> > +               __u64           config1; /* extension of config0 */
> >> > +       };
> >> > +       union {
> >> > +               __u64           bp_len;
> >> > +               __u64           config2; /* extension of config1 */
> >> > +       };
> >> >  };
> >> >
> >> I don't see where those config0 or config1 are coming from.
> >
> > config0 means perf_event_attr::config.
> >
> yes.
> 
> > Peter suggested to extend the attr config space.
> > http://marc.info/?l=linux-kernel&m=129838808907525&w=2
> >
> Ok, I get it, it is cascading. that's fine. 

I initially put config and config0 in a union, but that made compilation
fail and fixing that up vs the benefit of actually having a config0,
which seemed near 0, led me to drop that part. Forgot to update the
comment though ;-)

