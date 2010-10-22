Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0JVIRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:17:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:54627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab0JVIRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:17:47 -0400
Message-ID: <4CC14868.60809@kernel.org>
Date: Fri, 22 Oct 2010 10:16:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for trace_sched_wakeup.c
References: <1287508282.16971.386.camel@gandalf.stny.rr.com> <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu> <1287659656.16971.573.camel@gandalf.stny.rr.com> <20101021112614.GB26984@elte.hu> <20101022014441.GA1948@redhat.com>
In-Reply-To: <20101022014441.GA1948@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 08:16:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/22/2010 03:44 AM, Jason Baron wrote:
> (adding Tejun to the 'cc list)
> 
> I finally found that we actually continue to run after the above
> apparent 'hang'. That is, we continue to make progress updating the jump
> labels. And doing a dump of all the system tasks at the time of the hang
> showed the processes in various places besides the stop machine threads.
> Thus, I thought that perhaps, for some reason the stop machine threads
> weren't being scheduled.
> 
> Thus, I tried commenting out the special scheduling that is set up for
> stop machine threads, and that fixed the hang. I haven't yet looked into
> what might be going wrong with that scheduling...but maybe somebody else
> knows...

I'm afraid I don't have much idea about the new scheduling class.  I
liked the idea but Peter did all the hard working on it.  Peter?

Thanks.

-- 
tejun
