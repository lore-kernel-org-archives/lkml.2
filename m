Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0LQT1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:27:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40942 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab0LQT1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:27:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v1f+O4RJaWK1MxAxVMkz8rlqlMwT6oFJ5D8uvCQJ73xuqKCgxtzsJ3h3AxzWHzwrxq
         n1sUKwpW7dsnxzS1Bj+NE4ItX9mRhximTVx+bdR4z3ZDlboICOGPHwSZ+GZLPIOrwbF2
         jnSh6j29NzlGmHbF1DOhSYd+W/sGyH20ohrCk=
MIME-Version: 1.0
In-Reply-To: <1292612166.2697.68.camel@Palantir>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	<1292596194.2266.283.camel@twins>
	<1292612166.2697.68.camel@Palantir>
Date: Fri, 17 Dec 2010 20:27:51 +0100
Message-ID: <AANLkTinbaYvMFeU1KyeDZ9df1LEbsoKoWWgM8D4=fV1m@mail.gmail.com>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Harald Gustafsson <hgu1972@gmail.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/17 Dario Faggioli <raistlin@linux.it>:
> On Fri, 2010-12-17 at 15:29 +0100, Peter Zijlstra wrote:
>> Solving the CPUfreq problem involves writing a SCHED_DEADLINE aware
>> CPUfreq governor. The governor must know about the constraints placed on
>> the system by the task-set. You simply cannot lower the frequency when
>> your system is at u=1.
>>
> We already did the very same thing (for another EU Project called
> FRESCOR), although it was done in an userspace sort of daemon. It was
> also able to consider other "high level" parameters like some estimation
> of the QoS of each application and of the global QoS of the system.
>
> However, converting the basic mechanism into a CPUfreq governor should
> be easily doable... The only problem is finding the time for that! ;-P

I'm a bit choked before the holidays, but I can fix this in the
beginning of next year.
At the same time as I do a new version of the current patches that takes
in Peter's comments.

>> The simple solution would be to slow down the runtime accounting of
>> SCHED_DEADLINE tasks by freq/max_freq. So instead of having:
>>
>>   dl_se->runtime -= delta;
>>
>> you do something like:
>>
>>   dl_se->runtime -= (freq * delta) / max_freq;
>>
>> Which auto-magically grows the actual bandwidth, and since the deadlines
>> are wall-time already it all works out nicely. It also keeps the
>> overhead inside SCHED_DEADLINE.
>>
> And, at least for the meantime, this seems a very very nice solution.
> The only thing I don't like is that division which would end up in being
> performed at each tick/update_curr_dl(), but we can try to find out a
> way to mitigate this, what do you think Harald?

Yes, I will do something like this instead, need to make sure that
everything is consider first though.
