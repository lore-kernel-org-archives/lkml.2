Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab1CIW3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:29:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44226 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1CIW3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:29:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ubj4mpL1y7V2nGDffFXmPAmoq5JPFB8fCbZ+6JDVbqJ9rlGz8Ts5VjjdFLiXZjWIW5
         m80+HzNq0lqjtkYI4t3cWVAS0An00i93P76TgP+JvJQMykWYLwYpx6fpXnQxekmtzFRs
         3jzoKadQp+B9utgOUGWu+4Fofcp3wINZdVK3w=
Date: Wed, 9 Mar 2011 23:29:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] An RCU for SMP with a single CPU garbage collector
Message-ID: <20110309222914.GC1817@nowhere>
References: <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110307210157.GG3104@linux.vnet.ibm.com>
 <20110307211613.GA26455@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307211613.GA26455@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 04:16:13PM -0500, Joe Korty wrote:
> On Mon, Mar 07, 2011 at 04:01:57PM -0500, Paul E. McKenney wrote:
> > Interesting!
> > 
> > But I would really prefer leveraging the existing RCU implementations
> > to the extent possible.  Are the user-dedicated CPUs able to invoke
> > system calls?  If so, something like Frederic's approach should permit
> > the existing RCU implementations to operate normally.  If not, what is
> > doing the RCU read-side critical sections on the dedicated CPUs?
> > 
> >                                                         Thanx, Paul
> 
> I haven't seen Frederic's patch.  Sorry I missed it!
> It might have saved a bit of work...

I'm sorry it's my fault, I should have Cc'ed you in my nohz task series.

It's here: https://lkml.org/lkml/2010/12/20/209 and the rcu changes
are spread in severals patches of the series. The idea is to
switch to extended quiescent state when we resume to userspace but
temporarily exit that state when we trigger an exception or an
irq. Then exit extended quiescent state when we enter the kernel
again.

I'll soon look at the last patchset you've posted.
