Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab0EQUjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab0EQUjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:39:11 -0400
Date: Mon, 17 May 2010 23:33:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@relay.de.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC tip/core/rcu 23/23] vhost: add __rcu annotations
Message-ID: <20100517203349.GA14994@redhat.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com> <1273700022-16523-23-git-send-email-paulmck@linux.vnet.ibm.com> <20100512214847.GD22930@redhat.com> <20100512230057.GH2303@linux.vnet.ibm.com> <1273756043.5605.3542.camel@twins> <20100513152340.GA2879@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513152340.GA2879@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:23:40AM -0700, Paul E. McKenney wrote:
> On Thu, May 13, 2010 at 03:07:23PM +0200, Peter Zijlstra wrote:
> > On Wed, 2010-05-12 at 16:00 -0700, Paul E. McKenney wrote:
> > > Any thoughts?  One approach would be to create a separate lockdep class
> > > for vhost workqueue state, similar to the approach used in instrument
> > > rcu_read_lock() and friends. 
> > 
> > workqueue_struct::lockdep_map, its held while executing worklets.
> > 
> > lock_is_held(&vhost_workqueue->lockdep_map), should do as you want.
> 
> Thank you, Peter!!!
> 
> 							Thanx, Paul

vhost in fact does flush_work rather than
flush_workqueue, so while for now everything runs
from vhost_workqueue in theory nothing would break
if we use some other workqueue or even a combination
thereof.

I guess when/if this happens, we could start by converting
to _raw and then devise a solution.

By the way what would be really nice is if we had a way
to trap when rcu protected pointer is freed without a flush
while some reader is running. Current annotation does not
allow this, does it?

-- 
MST
