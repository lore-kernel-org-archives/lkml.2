Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2JST3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:29:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757094Ab2JST3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:29:19 -0400
Date: Fri, 19 Oct 2012 15:29:01 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: MAX_LOCKDEP_ENTRIES too low  (called from ioc_release_fn)
Message-ID: <20121019192901.GA8468@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20121018015312.GA29865@redhat.com>
 <507F9944.50505@kernel.dk>
 <20121019052136.GA30852@redhat.com>
 <1350650972.30157.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350650972.30157.34.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 02:49:32PM +0200, Peter Zijlstra wrote:

 > Of course, if you do run out of lock classes, the next thing to do is
 > to find the offending lock classes.  First, the following command gives
 > you the number of lock classes currently in use along with the maximum:
 > 
 >         grep "lock-classes" /proc/lockdep_stats
 > 
 > This command produces the following output on a modest system:
 > 
 >          lock-classes:                          748 [max: 8191]

After the BUG gets hit..

 lock-classes:                         1726 [max: 8191]

 > If the number allocated (748 above) increases continually over time,
 > then there is likely a leak.  The following command can be used to
 > identify the leaking lock classes:
 > 
 >         grep "BD" /proc/lockdep
 > 
 > Run the command and save the output, then compare against the output from
 > a later run of this command to identify the leakers.  This same output
 > can also help you find situations where runtime lock initialization has
 > been omitted.

I've not had chance to do this, because after the BUG, lockdep turns itself off,
and I've not rebooted. I'm probably not going to get to this until after the weekend.

There's just a *lot* of dependancies.

Here's the full output http://codemonkey.org.uk/junk/lockdep

the top few backwards deps..

ffffffff81c8f218 FD:    1 BD: 1201 -.-.-.: pool_lock
ffffffff82ae1210 FD:    2 BD: 1200 -.-.-.: &obj_hash[i].lock
ffffffff820677c1 FD:    1 BD: 1131 -.-.-.: &rt_rq->rt_runtime_lock
ffffffff82066949 FD:    3 BD: 1131 -.-.-.: &cpu_base->lock
ffffffff820221c0 FD:    1 BD: 1130 -.-.-.: &sig->cputimer.lock
ffffffff820677b8 FD:    5 BD: 1129 -.-.-.: &rt_b->rt_runtime_lock
ffffffff82067675 FD:    3 BD: 1129 ..-.-.: &rq->lock/1
ffffffff82067674 FD:    8 BD: 1128 -.-.-.: &rq->lock
ffffffff8298bbd0 FD:    1 BD: 1006 -.-.-.: &(&n->list_lock)->rlock

	Dave

