Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0K1BmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 20:42:10 -0500
Received: from smtp-out.google.com ([74.125.121.35]:2598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0K1BmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 20:42:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xnAyoA7acRrZS0QImWBJBwSIIB5wXrOiasozzDyEhQVppdurY2ElEUBtPcPh9IyXqn
         lph8pNFiDe2iF9nfXbbw==
Date: Sat, 27 Nov 2010 17:41:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20101123160259.7B9C.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011271737110.3764@chino.kir.corp.google.com>
References: <20101114135323.E00D.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141333330.22262@chino.kir.corp.google.com> <20101123160259.7B9C.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010, KOSAKI Motohiro wrote:

> > > No irrelevant. Your patch break their environment even though
> > > they don't use oom_adj explicitly. because their application are using it.
> > > 
> > 
> > The _only_ difference too oom_adj since the rewrite is that it is now 
> > mapped on a linear scale rather than an exponential scale.  
> 
> _only_ mean don't ZERO different. Why do userland application need to rewrite?
> 

Because NOTHING breaks with the new mapping.  Eight months later since 
this was initially proposed on linux-mm, you still cannot show a single 
example that depended on the exponential mapping of oom_adj.  I'm not 
going to continue responding to your criticism about this point since your 
argument is completely and utterly baseless.

> Again, IF you need to [0 .. 1000] range, you can calculate it by your
> application. current oom score can be get from /proc/pid/oom_score and
> total memory can be get from /proc/meminfo. You shouldn't have break
> anything.
> 

That would require the userspace tunable to be adjusted anytime a task's 
mempolicy changes, its nodemask changes, it's cpuset attachment changes, 
its mems change, a memcg limit changes, etc.  The only constant is the 
task's priority, and the current oom_score_adj implementation preserves 
that unless explicitly changed later by the user.  I completely understand 
that you may not have a use for this.
