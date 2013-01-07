Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3AGPk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:40:27 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62866 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3AGPkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:40:25 -0500
MIME-Version: 1.0
In-Reply-To: <20130107150422.GB3926@htj.dyndns.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<20121126171539.GZ15971@htj.dyndns.org>
	<CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
	<CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
	<20130104150928.GC15633@mtj.dyndns.org>
	<CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
	<20130107150422.GB3926@htj.dyndns.org>
Date: Mon, 7 Jan 2013 21:10:24 +0530
Message-ID: <CAP245DWaevohxZE9zguA4wN9crCHeqseuvQ-649tghD8ci3B5Q@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, venki@google.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Patch Tracking <patches@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paul.mckenney@linaro.org>, mingo@redhat.com,
        PDSW-power-team <pdsw-power-team@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, pjt@google.com,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 8:34 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Viresh.
>
> On Mon, Jan 07, 2013 at 03:28:33PM +0530, Viresh Kumar wrote:
>> Firstly the root cause of this patchset.
>>
>> Myself and some others in Linaro are working on ARM future cores:
>> big.LITTLE systems.
>> Here we have few very powerful, high power consuming cores (big,
>> currently A15's) and
>> few very efficient ones (LITTLE, currently A7's).
>>
>> The ultimate goal is to save as much power as possible without compromising
>> much with performance. For, that we wanted most of the stuff to run on LITTLE
>> cores and some performance-demanding stuff on big Cores. There are
>> multiple things
>> going around in this direction. Now, we thought A15's or big cores
>> shouldn't be used
>> for running small tasks like timers/workqueues and hence this patch is
>> an attempt
>> towards reaching that goal.
>
> I see.  My understanding of big.little is very superficial so there
> are very good chances that I'm utterly wrong, but to me it seems like
> more of a stop-gap solution than something which will have staying
> power in the sense that the complexity doesn't seem to have any
> inherent reason other than the failure to make the big ones power
> efficient enough while idle or under minor load.

The two processors use different manufacturing processes - one
optimised for performance, the other for really low power. So the
reason is physics at this point. Other architectures are known to be
playing with similar schemes. ARM's big.LITTLE is just the first one
to the market.

> Maybe this isn't specific to big.little and heterogeneous cores will
> be the way of future with big.little being just a forefront of the
> trend.  And even if that's not the case, it definitely doesn't mean
> that we can't accomodate big.little, but, at this point, it does make
> me a bit more reluctant to make wholesale changes specifically for
> big.little.

The patches aren't targeted to benefit only b.L systems though it was
definitely the trigger for our investigations. Our hope is that after
presenting more analysis results from our side we'll be able to
convince the community of the general usefulness of this feature.

Here are a few short introductions to big.LITTLE in case you're
interested.[1][2]

[1] http://www.arm.com/files/downloads/big.LITTLE_Final.pdf
[2] http://lwn.net/Articles/481055/
