Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665Ab2JaUIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:08:52 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52451 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab2JaUIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:08:50 -0400
Date: Wed, 31 Oct 2012 13:08:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Shan Wei <shanwei88@gmail.com>, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] rcu:  use this_cpu_ptr per-cpu helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
Message-ID: <20121031200842.GC3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50910A17.1090600@gmail.com>
 <0000013ab7eefc03-20a4ba94-f83f-4624-9dac-dfe3924277b4-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013ab7eefc03-20a4ba94-f83f-4624-9dac-dfe3924277b4-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103120-7408-0000-0000-000009D080E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 05:47:04PM +0000, Christoph Lameter wrote:
> On Wed, 31 Oct 2012, Shan Wei wrote:
> 
> > Signed-off-by: Shan Wei <davidshan@tencent.com>
> > ---
> >  kernel/rcutree.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 74df86b..3a21fcf 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1960,7 +1960,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
> >  	struct rcu_node *rnp_old = NULL;
> >
> >  	/* Funnel through hierarchy to reduce memory contention. */
> > -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> > +	rnp = this_cpu_ptr(rsp->rda)->mynode;
> 
> Do
> 
> 	rnp = this_cpu_read(rsp->rda->mynode);
> 
> instad.

One thing to keep in mind -- the only purpose of this is to diffuse
memory contention.  So there is no need to disable preemption.

							Thanx, Paul

