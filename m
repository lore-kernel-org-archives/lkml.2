Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2DXPW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:22:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48637 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab2DXPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:22:26 -0400
Message-ID: <4F96C52C.7030606@gmail.com>
Date: Tue, 24 Apr 2012 17:22:20 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 10/16] sched: add resource limits for -deadline tasks.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-11-git-send-email-juri.lelli@gmail.com> <1335280075.28150.202.camel@twins>
In-Reply-To: <1335280075.28150.202.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 05:07 PM, Peter Zijlstra wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>> From: Dario Faggioli<raistlin@linux.it>
>>
>> Add resource limits for non-root tasks in using the SCHED_DEADLINE
>> policy, very similarly to what already exists for RT policies.
>>
>> In fact, this patch:
>>   - adds the resource limit RLIMIT_DLDLINE, which is the minimum value
>>     a user task can use as its own deadline;
>>   - adds the resource limit RLIMIT_DLRTIME, which is the maximum value
>>     a user task can use as it own runtime.
>>
>> Notice that to exploit these, a modified version of the ulimit
>> utility and a modified resource.h header file are needed. They
>> both will be available on the website of the project.
>>
>> Signed-off-by: Dario Faggioli<raistlin@linux.it>
>> Signed-off-by: Juri Lelli<juri.lelli@gmail.com>
>
> I'm not sure this is the right way to go.. those existing things aren't
> entirely as useful/sane as one might hope either.
>
> The DLDLINE minimum is ok I guess, the DLRTIME one doesn't really do
> anything, by spawning multiple tasks one can still saturate the cpu and
> thus we have no effective control for unpriv users.
>
> Ideally DLRTIME would be a utilization cap per user and tracked in
> user_struct such that we can enforce a max utilization per user.
>
> This also needs a global (and possibly per-cgroup) user limit too to cap
> the total utilization of all users (excluding root) so that multiple
> users cannot combine their efforts in order to bring down the machine.
>
> In light of these latter controls the per-user control might be
> considered optional, furthermore I don't particularly like the rlimit
> infrastructure but I guess its the best we have for per-user like things
> if indeed we want to go there.

Ok, but considering what you said regarding setscheduler security problems:

On 04/24/2012 11:00 AM, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 09:21 +0200, Juri Lelli wrote:
>> >  Well, depends on how much effort will this turn to require. I personally
>> >  would prefer to be able to come out with a new release ASAP. Just to
>> >  continue the discussion with the most of the comments addressed and a
>> >  more updated code (I also have a mainline version of the patchset
>> >  quite ready).
> Right, one thing we can initially do is require root for using
> SCHED_DEADLINE and then when later work closes all the holes and we've
> added user bandwidth controls we can allow everybody in.

Are you suggesting to drop/postpone this to some later time?

Thanks,

- Juri
