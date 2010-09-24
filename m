Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab0IXU7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:59:39 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:40158 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab0IXU7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:59:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABeonExGGN6i/2dsb2JhbACiRXLHO4VDBA
Date: Fri, 24 Sep 2010 16:54:35 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 03/11] jump label: Base patch for jump label
Message-ID: <20100924205435.GB8304@Krystal>
References: <20100923034910.867858597@goodmis.org> <20100923035608.228041459@goodmis.org> <20100923143758.GA4022@Krystal> <20100923153902.GD2825@redhat.com> <20100923154852.GA12648@Krystal> <20100923184006.GE2825@redhat.com> <1285336460.31083.10.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1285336460.31083.10.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:53:00 up 170 days,  6:43,  2 users,  load average: 0.08, 0.19,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-09-23 at 14:40 -0400, Jason Baron wrote:
> 
> > I agree that we this synchronization for the module __init section.
> > 
> > However, I believe we are ok for module removal case. free_module() is
> > called *after* blocking_notifier_call_chain() call. The
> > blocking_notifier_call_chain() is going to call back into the jump label
> > code, grab the jump_label_mutex and remove the reference to the module that
> > is about to freed. Thus, the jump label code can no longer reference it.
> > 
> > So I think the following patch is all that is required here (lightly
> > tested).
> > 
> > Steve, I'll re-post as a separate patch, if we agree on this fix.
> 
> Ug, I'm struggling to get ready for my Tokyo trip. I'll try to look at
> it on the flight. But I still need to write my presentation :-)
> 
> I may have a response back till Monday or Tuesday.

As a note for when you review this patch, I have a strong preference for
adding a "pre-init-free notifier callback" rather than taking the rcu
read lock + adding a synchronize_rcu() in module.c. This will make our
life much easier when we end up doing modifications down in text_poke.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
