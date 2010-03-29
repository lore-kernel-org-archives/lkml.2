Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0C2Vvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:51:46 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54354 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab0C2Vvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:51:45 -0400
Date: Mon, 29 Mar 2010 14:51:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       abogani@texware.it, menage@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
Message-ID: <20100329215138.GP2569@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100329211525.GA17703@linux.vnet.ibm.com>
 <1269897564.12097.372.camel@laptop>
 <20100329212932.GO2569@linux.vnet.ibm.com>
 <20100329213405.GA18143@linux.vnet.ibm.com>
 <1269898975.12097.380.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269898975.12097.380.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 11:42:55PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-03-29 at 14:34 -0700, Paul E. McKenney wrote:
> 
> > And it appears that my patch is at best insufficient:
> > http://paste.ubuntu.com/406189/
> > 
> > Left to myself, I would wrap copy_process() with rcu_read_lock(),
> > but I would rather hear your thoughts before doing too much more
> > semi-random hacking.  ;-)
> 
> Well, I don't think you can get away with that, copy_process() wants to
> sleep on quite a few places ;-) Also, locks should be taken at the
> smallest possible scope, unless we want to go back to BKL style
> locking :-)

No argument here!  ;-)

> As to that freezer splat, you'd have to chase down the cgroup folks, I'm
> fully ignorant on that.

K, adding them to CC.  The two splats are:

	http://pastebin.ubuntu.com/406131/
	http://paste.ubuntu.com/406189/

Some additional RCU protection is required, or perhaps some suppression
of false positives.  Thoughts?

> For the set_task_rq() one, I'm afraid someone (which again I'm afraid
> will be me) will have to look into how the task_group muck ties into the
> cgroup muck as I think the original authors of that ran off :/

Sigh!

							Thanx, Paul
