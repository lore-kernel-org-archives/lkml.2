Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1FXLsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:48:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47551 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab1FXLsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U0O5Yqt7qQl6mfXaBwbkUI4hC+5ulaGbEx2g/jgLBYyZYBlDYUD9/MHMbyesPFhw/J
         gpq/EY6CI5rNbXsq5ZMqds2IU5DaeL6dd1e2bgsEx2c6IQiC8LP3oM26ANwlvLZzGcEr
         8KBrIF9hcpBSYT+MZpmwL3J5+MWPI3MjPpPPk=
Date: Fri, 24 Jun 2011 13:48:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3 v3] rcu: Detect rcu uses under extended quiescent
 state
Message-ID: <20110624114831.GG8058@somewhere.redhat.com>
References: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
 <1308907125.27849.19.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308907125.27849.19.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 11:18:45AM +0200, Peter Zijlstra wrote:
> On Fri, 2011-06-24 at 01:12 +0200, Frederic Weisbecker wrote:
> > This time I have no current practical cases to fix. Those I fixed
> > in previous versions were actually using rcu_dereference_raw(), which
> > is legal in extended qs.
> > 
> > Frederic Weisbecker (3):
> >   rcu: Detect illegal rcu dereference in extended quiescent state
> >   rcu: Inform the user about dynticks idle mode on PROVE_RCU warning
> >   rcu: Warn when rcu_read_lock() is used in extended quiescent state
> > 
> >  include/linux/rcupdate.h |   68 +++++++++++++++++++++++++++++++++++++++-------
> >  kernel/lockdep.c         |    4 +++
> >  kernel/rcupdate.c        |    4 +++
> >  kernel/rcutiny.c         |   13 +++++++++
> >  kernel/rcutree.c         |   14 +++++++++
> >  5 files changed, 93 insertions(+), 10 deletions(-)
> 
> Right, so the only comment I have is that it might have been nice to
> explain what the heck an extended qs is :-) I've since figured it out,
> but it did require waking up my brain.

Hehe, right :)

As I have scratched my head for some times with rcu dynticks for the nohz cpuset
things, I guess that in the meantime my unconscious mind developed the idea that rcu extended
quiescent states were a worldwide topic that every people talk about in dinner with their family,
that these even became the core stories of some lullabies. I can still hear its chorus, that makes
one switching to idle peacefully...
