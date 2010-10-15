Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0JOQUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:20:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11897 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab0JOQUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rw0VAMCq6oBp/ThbqD4TtEUS6x2/Ypog55JLpNK/BBOYMGBFUnkihKHoWrIWcfTdjs
         gGbxue2MfBDB/++74I+g==
MIME-Version: 1.0
In-Reply-To: <1287146110.9200.43.camel@marge.simson.net>
References: <1286996978-7007-1-git-send-email-ncrao@google.com>
 <1286996978-7007-5-git-send-email-ncrao@google.com> <1287144395.29097.1462.camel@twins>
 <1287145129.9200.32.camel@marge.simson.net> <1287145214.29097.1464.camel@twins>
 <1287146110.9200.43.camel@marge.simson.net>
From: Nikhil Rao <ncrao@google.com>
Date: Fri, 15 Oct 2010 09:19:35 -0700
Message-ID: <AANLkTimiXtoiOGgoYMUN3oz24bJ=2B_bK3qoydoHRUZf@mail.gmail.com>
Subject: Re: [PATCH 4/4] sched: force balancing on newidle balance if local
 group has capacity
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 5:35 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Fri, 2010-10-15 at 14:20 +0200, Peter Zijlstra wrote:
>> On Fri, 2010-10-15 at 14:18 +0200, Mike Galbraith wrote:
>> > On Fri, 2010-10-15 at 14:06 +0200, Peter Zijlstra wrote:
>> > > On Wed, 2010-10-13 at 12:09 -0700, Nikhil Rao wrote:
>> > > > +bool check_utilization(struct sd_lb_stats *sds)
>> > > > +{
>> > > > +       if (!sds->this_has_capacity || sds->busiest_has_capacity)
>> > > > +               return false;
>> > > > +
>> > > > +       return true;
>> > > > +}
>> > > > +
>> > > >  /******* find_busiest_group() helpers end here *********************/
>> > > >
>> > > >  /**
>> > > > @@ -2824,6 +2845,10 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
>> > > >         if (!sds.busiest || sds.busiest_nr_running == 0)
>> > > >                 goto out_balanced;
>> > > >
>> > > > +       /*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
>> > > > +       if (idle == CPU_NEWLY_IDLE && check_utilization(&sds))
>> > > > +               goto force_balance;
>> > >
>> > >
>> > > Is that really worth an extra function?
>> >
>> > (I did that)
>> >
>> > No, just it made it look prettier to me.  I figured the compiler will
>> > nuke it at zero cost.
>>
>> Sure.. but it does raise the whole naming/confusion angle ;-)
>
> is_under_utilized() works for me.
>
> (as does && this && that or cpu_should_get_off_lazy_butt():)
>

Let's go with the latter for now. If that condition gets more
complicated, then we can factor it out into a different function, like
is_under_utilized().

I'll update the patch and send it out.

-Thanks
Nikhil
