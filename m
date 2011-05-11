Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab1EKQ4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:56:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55839 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab1EKQ4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OO0PejAnniemhkWXwrRRSU4iPz67kaBbR0bMHPvJESR5SYpM5AnJHVu2NPKW8j2+SE
         3XoT5/Lyw6ZvwBmOXKOtpjlfPb8LrbnApGH42AlcDREBU5lBpdJDAu44GMHrGEAYBp/W
         qyot1eyRaYEBPNb3fWpLakaBcr26QO+KAjPTg=
MIME-Version: 1.0
In-Reply-To: <20110511045443.GS2258@linux.vnet.ibm.com>
References: <20110508151848.GA21906@linux.vnet.ibm.com>
	<20110509073636.GA18247@elte.hu>
	<BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com>
	<20110510085623.GG2258@linux.vnet.ibm.com>
	<4DC97E49.7040401@kernel.org>
	<20110510193216.GN2258@linux.vnet.ibm.com>
	<4DC9A5A4.1050308@kernel.org>
	<20110511045443.GS2258@linux.vnet.ibm.com>
Date: Wed, 11 May 2011 09:56:35 -0700
X-Google-Sender-Auth: ERPtIhpvdN0da0M4KN0Oe5B5ab4
Message-ID: <BANLkTi=r707A9yy5-7+dw3Hozt=G1HBQ-Q@mail.gmail.com>
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
From: Yinghai Lu <yinghai@kernel.org>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 9:54 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, May 10, 2011 at 01:52:52PM -0700, Yinghai Lu wrote:
>> On 05/10/2011 12:32 PM, Paul E. McKenney wrote:
>> > On Tue, May 10, 2011 at 11:04:57AM -0700, Yinghai Lu wrote:
>> >> On 05/10/2011 01:56 AM, Paul E. McKenney wrote:
>> >>> On Mon, May 09, 2011 at 02:09:21PM -0700, Yinghai Lu wrote:
>> >>>> On Mon, May 9, 2011 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >>>>>
>> >>>>> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>> >>>>>
>> >>>>>> Hello, Ingo,
>> >>>>>>
>> >>>>>> This pull request covers RCU chnages for 2.6.40.  The major new features
>> >>>>>> are RCU priority boosting and the addition of kfree_rcu(), the latter
>> >>>>>> courtesy of Lai Jiangshan.  These two features cover well over half
>> >>>>>> of the commits.  There are a number of smaller features and bug fixes.
>> >>>>>> All have been sent to LKML in the following batches:
>> >>>>>>
>> >>>>>> 0.    https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
>> >>>>>> 1.    https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
>> >>>>>> 2.    https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
>> >>>>>> 3.    https://lkml.org/lkml/2011/5/8/60: miscellaneous
>> >>>>>>
>> >>>>>> The kfree_rcu() uses in the pull request have Acked-by:s from the
>> >>>>>> maintainers.  I have some additional kfree_rcu() requests that lack
>> >>>>>> Acked-by:s, and I will deal with these later.
>> >>>>>>
>> >>>>>> These channges are available in the -rcu git repository at:
>> >>>>>>
>> >>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
>> >>>>>
>> >>>>> Pulled, thanks a lot Paul!
>> >>>>>
>> >>>>
>> >>>> it seems with this one in tip, my 8 sockets test setup will report cpu stall.
>> >>>>
>> >>>> after hard code to enable rcu_cpu_stall_suppress
>> >>>>
>> >>>> Index: linux-2.6/kernel/rcutree.c
>> >>>> ===================================================================
>> >>>> --- linux-2.6.orig/kernel/rcutree.c
>> >>>> +++ linux-2.6/kernel/rcutree.c
>> >>>> @@ -174,7 +174,7 @@ module_param(blimit, int, 0);
>> >>>>  module_param(qhimark, int, 0);
>> >>>>  module_param(qlowmark, int, 0);
>> >>>>
>> >>>> -int rcu_cpu_stall_suppress __read_mostly;
>> >>>> +int rcu_cpu_stall_suppress __read_mostly = 1;
>> >>>>  module_param(rcu_cpu_stall_suppress, int, 0644);
>> >>>>
>> >>>>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
>> >>>>
>> >>>> will get system hang after pnp ACPI init.
>> >>>
>> >>> Could you please send the stack traces from the RCU CPU stall?  Also,
>> >>> you do have ce31332d3c77532d6ea97ddcb475a2b02dd358b4 applied, correct?
>> >>>
>> >>>                                                   Thanx, Paul
>> >>
>> >> Do not have time to bisect it at this point.
>> >
>> > Could you please send the stack traces from the RCU CPU stall?
>
> Thank you!  OK, so CPU 0 has not been responding, despite resched IPIs.
> Everyone is idle, except for CPU 124, which detected the stall, and
> possibly CPU 0, which has csum_partial_copy_generic() on the stack, though
> that looks like a backtrace error to me.  The fact that it hangs if you
> disable RCU CPU stall detection leads me to believe that something real
> is being detected.

the problem is that now I can not disable RCU CPU stall detection any more.

Thanks

Yinghai
