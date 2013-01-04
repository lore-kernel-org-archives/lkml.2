Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3ADPJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 10:09:35 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62025 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab3ADPJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 10:09:32 -0500
Date: Fri, 4 Jan 2013 10:09:28 -0500
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, pjt@google.com,
        paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
Message-ID: <20130104150928.GC15633@mtj.dyndns.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
 <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
 <20121126171539.GZ15971@htj.dyndns.org>
 <CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
 <CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Viresh.

On Fri, Jan 04, 2013 at 04:41:47PM +0530, Viresh Kumar wrote:
> I got a list of files where cpu/processor_id strings are found, which
> may break with
> this patch (still can't guarantee as i don't have knowledge of these drivers)...
...
> I am not sure what to do now :) , can you assist ?

I don't know either.  Changing behavior subtly like this is hard.  I
usually try to spot some problem cases and try to identify patterns
there.  Once you identify a few of them, understanding and detecting
other problem cases get a lot easier.  In this case, maybe there are
too many places to audit and the problems are too subtle, and, if we
*have* to do it, the only thing we can do is implementing a debug
option to make such problems more visible - say, always schedule to a
different cpu on queue_work().

That said, at this point, the patchset doesn't seem all that
convincing to me and if I'm comprehending responses from others
correctly that seems to be the consensus.  It might be a better
approach to identify the specific offending workqueue users and make
them handle the situation more intelligently than trying to impose the
behavior on all workqueue users.  At any rate, we need way more data
showing this actually helps and if so why.

Thanks.

-- 
tejun
