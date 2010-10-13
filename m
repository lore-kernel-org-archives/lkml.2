Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab0JMLT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:19:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54382 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab0JMLTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:19:25 -0400
Date: Wed, 13 Oct 2010 13:19:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [patch]x86: spread tlb flush vector between nodes
Message-ID: <20101013111913.GA32131@elte.hu>
References: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>
 <20101013081629.GA1621@basil.fritz.box>
 <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shaohua Li <shaohua.li@intel.com> wrote:

> On Wed, 2010-10-13 at 16:16 +0800, Andi Kleen wrote:
> > On Wed, Oct 13, 2010 at 03:41:38PM +0800, Shaohua Li wrote:
> > > +
> > > +static int tlb_cpuhp_notify(struct notifier_block *n,
> > > +		unsigned long action, void *hcpu)
> > > +{
> > > +	switch (action & 0xf) {
> > > +	case CPU_ONLINE:
> > > +	case CPU_DEAD:
> > > +		calculate_tlb_offset();
> > > +	}
> > > +	return NOTIFY_OK;
> > 
> > I don't think we really need the complexity of a notifier here.
> > In most x86 setups possible is very similar to online.
> > 
> > So I would suggest simply to compute a static mapping at boot
> > and simplify the code.
> > 
> > In theory there is a slight danger of node<->CPU numbers
> > changing with consecutive hot plug actions, but right now
> > this should not happen anyways and it would be unlikely
> > later.
>
> yes, it's unlikely. could we get the node info for a CPU before it's 
> hotplugged? Anyway, this doesn't take overhead.

It would be rather stupid to throw away the fairly simple hotplug-aware 
code you wrote and replace it with some lame boot-time calculated 
mapping just because currently it's considered rare.

Thanks,

	Ingo
