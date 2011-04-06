Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab1DFOjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab1DFOje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:39:34 -0400
Message-ID: <4D9C7BE1.6010502@redhat.com>
Date: Wed, 06 Apr 2011 10:42:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Alex Shi <alex.shi@intel.com>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        tim.c.chen@intel.com, shaohua.li@intel.com
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com> <1302077064.2225.1357.camel@twins>
In-Reply-To: <1302077064.2225.1357.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 04:04 AM, Peter Zijlstra wrote:
> On Wed, 2011-04-06 at 06:33 +0800, Alex Shi wrote:
>> commit ac53db596cc08ecb8040c removed the sched_yield task running
>> time increase, so the yielded task get more opportunity to be launch
>> again. That may not the caller want to be. And this also causes
>> volano benchmark drop 50~80 percent performance on core2/NHM/WSM
>> machines. This patch recover the sched_yield task vruntime up.
>
> You do know that any app that relies on sched_yield behaviour is more
> than broken? Using sched_yield() for anything other than SCHED_FIFO
> tasks is well outside spec.
>
> Furthermore, apparently you used sysctl_sched_compat_yield, which was
> bound to disappear some time, since with the default settings the yield
> semantics didn't actually change.
>
> So no, I'm not much inclined to accept this. The Java people have had
> every opportunity to go fix their crap, them not doing so will
> eventually (preferably now) stop being my problem.

It appears they might not have figured out how to fix
their stuff :)

Would you have any hints on what the Java folks should
replace their calls to sched_yield with?

Proper use of futexes from inside the JVM perhaps?

Or should we export yield_to to userspace and have
them use that? :)   *runs*
