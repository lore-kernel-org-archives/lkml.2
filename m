Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab1I3XGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:06:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65240 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1I3XGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:06:39 -0400
Date: Fri, 30 Sep 2011 16:06:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] stop_machine: make stop_machine safe and efficient
 to call early
Message-ID: <20110930230635.GA2658@mtj.dyndns.org>
References: <4E85EE1F.7050508@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E85EE1F.7050508@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeremy.

On Fri, Sep 30, 2011 at 09:28:15AM -0700, Jeremy Fitzhardinge wrote:
> Make stop_machine() safe to call early in boot, before SMP has been
> set up, by simply calling the callback function directly if there's
> only one CPU online.
...
> @@ -485,6 +485,9 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>  					    .num_threads = num_online_cpus(),
>  					    .active_cpus = cpus };
>  
> +	if (smdata.num_threads == 1)
> +		return (*fn)(data);
> +

As others have pointed out, you'll need to call both local and hardirq
disables.  Also, I think the description and the code are a bit
misleading.  How aobut setting cpu_stop_initialized in cpu_stop_init()
and testing it from __stop_machine() instead?  I think it would be
better to keep the behavior as uniform as possible once things are up
and running.

Thank you.

-- 
tejun
