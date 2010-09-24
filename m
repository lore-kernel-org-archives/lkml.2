Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0IXVq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab0IXVq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:46:28 -0400
Date: Fri, 24 Sep 2010 17:45:29 -0400
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 03/11] jump label: Base patch for jump label
Message-ID: <20100924214529.GG2887@redhat.com>
References: <20100923034910.867858597@goodmis.org> <20100923035608.228041459@goodmis.org> <20100923143758.GA4022@Krystal> <20100923153902.GD2825@redhat.com> <20100923154852.GA12648@Krystal> <20100923184006.GE2825@redhat.com> <1285336460.31083.10.camel@gandalf.stny.rr.com> <20100924205435.GB8304@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924205435.GB8304@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 04:54:35PM -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Thu, 2010-09-23 at 14:40 -0400, Jason Baron wrote:
> > 
> > > I agree that we this synchronization for the module __init section.
> > > 
> > > However, I believe we are ok for module removal case. free_module() is
> > > called *after* blocking_notifier_call_chain() call. The
> > > blocking_notifier_call_chain() is going to call back into the jump label
> > > code, grab the jump_label_mutex and remove the reference to the module that
> > > is about to freed. Thus, the jump label code can no longer reference it.
> > > 
> > > So I think the following patch is all that is required here (lightly
> > > tested).
> > > 
> > > Steve, I'll re-post as a separate patch, if we agree on this fix.
> > 
> > Ug, I'm struggling to get ready for my Tokyo trip. I'll try to look at
> > it on the flight. But I still need to write my presentation :-)
> > 
> > I may have a response back till Monday or Tuesday.
> 
> As a note for when you review this patch, I have a strong preference for
> adding a "pre-init-free notifier callback" rather than taking the rcu
> read lock + adding a synchronize_rcu() in module.c. This will make our
> life much easier when we end up doing modifications down in text_poke.
> 
> Thanks,
> 
> Mathieu
> 

Yes, I think we can make this work with a "pre-init-free notifier
callback". In fact, we can use MODULE_STATE_LIVE state that is already
in module.c. I'm in the process of testing a patch using this
alternative method.

thanks,

-Jason
