Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab2LMQcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:32:41 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59962 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2LMQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:32:39 -0500
Date: Thu, 13 Dec 2012 08:32:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU
 offline from atomic context
Message-ID: <20121213163233.GA2728@htj.dyndns.org>
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com>
 <20121211140358.23621.97011.stgit@srivatsabhat.in.ibm.com>
 <20121212171720.GA22289@redhat.com>
 <50C8C4A5.4080104@linux.vnet.ibm.com>
 <20121212180248.GA24882@redhat.com>
 <50C8CD52.8040808@linux.vnet.ibm.com>
 <20121212184849.GA26784@redhat.com>
 <50C8D739.6030903@linux.vnet.ibm.com>
 <50C9F38F.3020005@linux.vnet.ibm.com>
 <20121213161709.GA19125@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213161709.GA19125@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Thu, Dec 13, 2012 at 05:17:09PM +0100, Oleg Nesterov wrote:
> Hmm. I thought that __this_cpu_* must be safe under preempt_disable().
> IOW, I thought that, say, this_cpu_inc() is "equal" to preempt_disable +
> __this_cpu_inc() correctness-wise.

this_cpu_inc() equals local_irq_save() + __this_cpu_inc().

> And. I thought that this_cpu_inc() is safe wrt interrupt, like local_t.

Yes, it is safe.

> But when I try to read the comments percpu.h, I am starting to think that
> even this_cpu_inc() is not safe if irq handler can do the same?
> 
> Confused...

Yeah, the comment is confusing and the way these macros are defined
doesn't help.  There used to be three variants and it looks like we
didn't update the comment while removing the preempt safe ones.  Gotta
clean those up.  Anyways, yes, this_cpu_*() are safe against irqs.

Thanks.

-- 
tejun
