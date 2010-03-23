Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0CWU4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:56:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60622 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab0CWU4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OpTBAdDVvKewec3gAjCNTyKrK3t6ZGepgZph+x5OOJEHhHyK0z4KK/vDXUwmd3A6HN
         vp99PTlfdxhiU5OxcALdZJwoc3PBwhcUAnafgwpmfCzW6EyxGNlun4yCUVRe9MnEcEkM
         gJWSOY8BaUqgRdVmQ1tYqH9yhftxThEuNW3YU=
Date: Tue, 23 Mar 2010 21:56:23 +0100
From: Dhaval Giani <dhaval@retis.sssup.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fabio Checconi <fchecconi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] sched: use EDF to throttle RT task groups v2
Message-ID: <20100323205623.GA9138@gondor.retis>
References: <cover.1266931410.git.fabio@helm.retis>
 <1267273991.22519.744.camel@laptop>
 <20100303170110.GS2490@gandalf.sssup.it>
 <1269376207.5283.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269376207.5283.5.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > The biggest problem with the four files used in the current implementation
> > is that bandwidth assignments should be atomic (because setting all the
> > parameters independently can force the system to go through non-feasible
> > assignments, and the order to use when assigning runtime and period
> > changes depending on the direction of the change).  I know this is a
> > dangerous question, but I'll try it anyway: are we ready for multi-valued
> > cgroup parameters?
> 
> Right, I don't know about multi-valued files, that sounds like its going
> to confuse people too.
> 

True, but after having used the current interface I feel multi-valued
files will be better. For an idea, this is how I currently change
bandwidth allocated to a group.

(I am ignoring cpu.rt_ prefixes and _us suffixes for the filenames)

Starting state: task_runtime: 100000, task_period: 1000000.
runtime=200000, period=1000000

Suppose I want to bring down the periods to 100000, then first I need
to change task_runtime to 10000, then the task period, then the runtime
and finally the period.

If I want to go the opposite way, then first I need to increase the
periods and then the runtimes.

But I can also see why one would not want a multi-valued interface, esp
when the idea is just to change the runtimes. (though there is a
complicated interaction between task_runtime and runtime which I am not
sure how to avoid).

IOW, this interface sucks :-). We really need something better and
easier to use. (Sorry for no constructive input)

Thanks,
Dhaval
