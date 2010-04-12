Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab0DLTZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:25:05 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:38897 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0DLTZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:25:04 -0400
X-Originating-IP: 217.70.178.42
X-Originating-IP: 173.50.255.69
Date: Mon, 12 Apr 2010 12:24:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH tip/core/urgent 1/4] rcu: add rcu_access_pointer and
 rcu_dereference_protected
Message-ID: <20100412192441.GB27341@feather>
References: <1270792042-9358-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100409054701.GA8833@linux.vnet.ibm.com>
 <23572.1270804211@redhat.com>
 <1270805058.2623.72.camel@edumazet-laptop>
 <20100409165735.GB2421@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100409165735.GB2421@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 09:57:35AM -0700, Paul E. McKenney wrote:
> On Fri, Apr 09, 2010 at 11:24:18AM +0200, Eric Dumazet wrote:
> > Le vendredi 09 avril 2010 à 10:10 +0100, David Howells a écrit :
> > > Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > +#define rcu_access_pointer(p) ((void *)ACCESS_ONCE(p))
> > > > ...
> > > > +#define rcu_access_pointer(p)		((void *)ACCESS_ONCE(p))
> > > 
> > > There's no difference between your two versions of rcu_access_pointer(), so
> > > you could move that whole construct outside of the #ifdef'ed section.
> > > 
> > > Other than that:
> > > 
> > > Acked-by: David Howells <dhowells@redhat.com>
> > 
> > I also prefer to keep type checking if possible
> > 
> > #define rcu_access_pointer(p)		(ACCESS_ONCE(p))
> 
> Yikes!  I was obsessing on preventing people from dereferencing the
> pointer, but you are quite right, they might be comparing it to a
> constant pointer to check for array bounds or for use of a statically
> allocated emergency-pool item.

If you want to prevent people from deferencing the pointer directly, or
from assigning it to some other pointer, you could use Sparse's
__attribute__((noderef)) and
__attribute__((address_space(...)).

See the definitions of __user and __iomem in include/linux/compiler.h
for instance.  (And, looking at that file, now __percpu.  Nice!)

You'd then have to explicitly use __force at the point where you
legitimately dereference it.

- Josh Triplett
