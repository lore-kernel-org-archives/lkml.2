Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2JTHJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 03:09:53 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:40614 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2JTHJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 03:09:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponGwhC_zmk1Whq56vmZMvjcxXKiSpdvMk4ZU8z0Wa2TBw@mail.gmail.com>
References: <32e5bed743cc6cc4e614291a7080299f5f0d0933.1350677395.git.viresh.kumar@linaro.org>
	<2737823.2JYE7UmLRN@vostro.rjw.lan>
	<CAKohponGwhC_zmk1Whq56vmZMvjcxXKiSpdvMk4ZU8z0Wa2TBw@mail.gmail.com>
Date: Sat, 20 Oct 2012 12:39:50 +0530
Message-ID: <CAKohpo=syf8gu8KFXgy-k9GsjrEfLqQNgpOuoZ1dqio6Cfo-4Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: return early from __cpufreq_driver_getavg()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pdsw-power-team@arm.com, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending, as it bounced from the lists :(
When i reply to mail from my Samsung S2, it replies in HTML format.
Don't know how to fix it :)

On 20 October 2012 10:12, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> On Oct 20, 2012 3:37 AM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>>
>> On Saturday 20 of October 2012 01:42:05 Viresh Kumar wrote:
>> > There is no need to do cpufreq_get_cpu() and cpufreq_put_cpu() for
>> > drivers that
>> > don't support getavg() routine.
>> >
>> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>
>> The patch doesn't seem to follow the changelog or the other way around.
>
> Sorry if my log isn't clear enough.
> But i could still see it matching the code :)
>
> I have moved the check for drivers capabilities at the top
> of routine, so that there is no need to call mentioned routines.
>
>>
>> Thanks,
>> Rafael
>>
>>
>> > ---
>> >  drivers/cpufreq/cpufreq.c | 6 ++++--
>> >  1 file changed, 4 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> > index 85df538..f552d5f 100644
>> > --- a/drivers/cpufreq/cpufreq.c
>> > +++ b/drivers/cpufreq/cpufreq.c
>> > @@ -1511,12 +1511,14 @@ int __cpufreq_driver_getavg(struct
>> > cpufreq_policy *policy, unsigned int cpu)
>> >  {
>> >       int ret = 0;
>> >
>> > +     if (!(cpu_online(cpu) && cpufreq_driver->getavg))
>> > +             return 0;
>> > +
>> >       policy = cpufreq_cpu_get(policy->cpu);
>> >       if (!policy)
>> >               return -EINVAL;
>> >
>> > -     if (cpu_online(cpu) && cpufreq_driver->getavg)
>> > -             ret = cpufreq_driver->getavg(policy, cpu);
>> > +     ret = cpufreq_driver->getavg(policy, cpu);
>> >
>> >       cpufreq_cpu_put(policy);
>> >       return ret;
>> >
>> --
>> I speak only for myself.
>> Rafael J. Wysocki, Intel Open Source Technology Center.
