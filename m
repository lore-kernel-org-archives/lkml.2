Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab0DGRN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:13:56 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48321 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040Ab0DGRNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:13:55 -0400
Date: Wed, 7 Apr 2010 10:13:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/urgent] rcu: add rcu_access_pointer and
 rcu_dereference_protected
Message-ID: <20100407171342.GF2481@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100407162620.GA11543@linux.vnet.ibm.com>
 <27310.1270659627@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27310.1270659627@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 06:00:27PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > The new rcu_access_pointer() primitive is for the case where the pointer
> > is be fetch and not dereferenced.  This primitive may be used without
> > protection, RCU or otherwise, due to the fact that it uses ACCESS_ONCE().
> > ...
> > +#define rcu_access_pointer(p, c) \
> 
> NAK.  This shouldn't have the conditional parameter 'c'.  Given that 'c' (by
> analogy to rcu_dereference_check()) is there to describe the conditions under
> which it's permitted to dereference the pointer, why is that relevant here?
> What is it you're proving?

In some cases, the value of 'c' will indeed be '1', and in those cases,
there needs to be a comment stating why it is OK, similar to those
required for smp_mb() and friends.

In other cases, there will be a reference counter or a "not yet fully
initialized" flag that can (and should) be tested.

							Thanx, Paul
