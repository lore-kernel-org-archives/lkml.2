Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0LUN2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:28:32 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:39192 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0LUN2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:28:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n6dM65B3OQdJTTZCPpEaVv0Bk8Ns5cFI94roe4Dc2vvw5kpcvaxKn/NIY3cW20Vktf
         jWSvHXw9FQ+UyewCsbXT8RIlaAdsbQ76BoJd2qyXN/KR7FzSYBCj6MTUNgGWRNq0S30F
         hX61uqbI1gBitsno0GOkvi6IXhVZJ0oXhjerk=
Date: Tue, 21 Dec 2010 14:28:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 07/15] nohz_task: Restart tick when RCU forces nohz
 task cpu quiescent state
Message-ID: <20101221132824.GC1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-8-git-send-email-fweisbec@gmail.com>
 <1292860929.5021.16.camel@laptop>
 <20101220235158.GE1715@nowhere>
 <1292917274.5021.173.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292917274.5021.173.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 08:41:14AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 00:52 +0100, Frederic Weisbecker wrote:
> > On Mon, Dec 20, 2010 at 05:02:09PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > > If a cpu is in nohz mode due to a nohz task running, then
> > > > it is not able to notify quiescent states requested by other
> > > > CPUs.
> > > > 
> > > > Then restart the tick to remotely force the quiescent states on the
> > > > nohz task cpus.
> > > 
> > > -ENOPARSE.. if its in NOHZ state, it couldn't possibly need to
> > > participate in the quiescent state machine because the cpu is in a
> > > quiescent state and has 0 RCU activity.
> > 
> > 
> > But it can be in nohz state in the kernel in which case it can have
> > any RCU activity.
> 
> That still doesn't make sense.. if you're in nohz state there shouldn't
> be any rcu activity, otherwise its not nohz is it?
> 
> 

nohz only means that the tick is stopped, that we don't have
anymore a periodic but purely on need event.

Now rcu takes appropriate action to that new state accordingly.
If it's idle or in userspace, then it can enter into extended
quiescent state. If not then it can't.

So nohz and extended qs must be two different things now.
