Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1CKIN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 03:13:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59234 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1CKIN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 03:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uyKYhqkxjdV2WI0GCYqVhP7zY/dqmQAGu3UPnywahQqwH6aXl1bt5ISbDWo0Oc70RL
         7er7SYhZgsdpSMS5t9C0YHBJ70JdMza6llEGRddef4HnjwVT8i5qqZgwNqFOI3BimFed
         Iq0YgyMK6n7W9SxnEO/seY/3WCieLkMQriqq4=
Date: Fri, 11 Mar 2011 09:13:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110311081320.GB13038@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110307204346.19557183C29@magilla.sf.frob.com>
 <20110309102855.GC27010@htj.dyndns.org>
 <20110310183305.GD12521@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310183305.GD12521@home.goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven.

On Thu, Mar 10, 2011 at 01:33:06PM -0500, Steven Rostedt wrote:
> > Use tracing for tracing.
> 
> Hmm, what tracing utility exactly? If I want to trace a running task,
> that I have the debug info on it where I would have the ability to
> insert probes, which utility would you recommend?
>
> strace and gdb use ptrace

strace only monitors kernel events - syscalls, fork, exit and signals.
We'll probably need to beef up the tracepoints a bit to reach feature
parity but it shouldn't be too difficult and provides much better
insight into what happens inside the kernel.

> ftrace focuses on the kernel.
> 
> I don't think perf has a good way to trace userspace yet.
> 
> I haven't taken a good look at lttng, but I think it has some sort of
> library that is attached to the process. Is there a better way than
> attching a library to said task.
> 
> systemtap may have ways too, but I think it depends on utrace which has
> pretty much been nak'd in the kernel.

I don't have much idea on how to do userland tracing but am pretty
sure ptrace is not the answer.  ptrace involves switching to another
process context and back on each event.  It just ain't gonna work and
none of Roland's suggestions changes anything about that.

Thanks.

-- 
tejun
