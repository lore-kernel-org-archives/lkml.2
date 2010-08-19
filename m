Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab0HSXOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 19:14:25 -0400
Received: from mail.lang.hm ([64.81.33.126]:40729 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab0HSXOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 19:14:22 -0400
Date: Thu, 19 Aug 2010 16:10:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, arve@android.com,
        mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <20100813151451.GC2511@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008191600310.8334@asgard.lang.hm>
References: <20100809181638.GI3026@linux.vnet.ibm.com> <20100809201822.441905f7@lxorguk.ukuu.org.uk> <20100810044541.GA2817@linux.vnet.ibm.com> <20100810093849.138e2318@lxorguk.ukuu.org.uk> <20100811004223.GH2379@linux.vnet.ibm.com>
 <AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com> <20100811221258.GI2516@linux.vnet.ibm.com> <AANLkTi=fJjM=uWeV+L66ajM9rhrL0t1OO-C7ThNRdbae@mail.gmail.com> <20100812161935.GC2524@linux.vnet.ibm.com> <AANLkTi=51cFa0t5ZYj2CMiauuW80ZWTrm1tQkn63Et0F@mail.gmail.com>
 <20100813151451.GC2511@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-54885766-1282259417=:8334"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-54885766-1282259417=:8334
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 13 Aug 2010, Paul E. McKenney wrote:

> On Thu, Aug 12, 2010 at 08:52:22PM +0300, Felipe Contreras wrote:
>> On Thu, Aug 12, 2010 at 7:19 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>>> On Thu, Aug 12, 2010 at 03:17:29AM +0300, Felipe Contreras wrote:
>>>>> It seems to me that the same social-engineering approaches work in
>>>>> both cases.
>>>>
>>>> Yes, but if dynamic PM works as advertised, you don't need
>>>> opportunistic suspend.
>>>
>>> For dynamic power management to totally eliminate the need for something
>>> like suspend blockers, you are having to make some brave assumptions.
>>> Yes, dynamic power management is quite useful, but there is a big
>>> difference between something being useful and something doing everything
>>> for everyone.  You have not yet convinced me that dynamic power management
>>> will make it to the "doing everything for everyone" stage.
>>
>> As it has been explained before, there's a sweet-spot of idleness:
>> http://article.gmane.org/gmane.linux.kernel/995525
>> http://article.gmane.org/gmane.linux.ports.arm.omap/37982
>>
>> Do you agree that there's such a thing, and if so, do you agree that
>> the benefits of opportunistic suspend are much less once that point is
>> reached?
>
> I agree that there will be a sweet spot of idleness (though I would call
> it a "point of diminishing returns"), but only if all the applications
> are power-optimized.  The advantage of opportunistic suspend is instead
> its tolerance of power-oblivious applications with minimal degradation
> of battery life.

sorry for the late response, the last week has been very hectic.

I just wanted to note that there is already a tool in the kernel to deal 
with this, the timer jitter/fuzz control. This can be set by an 
application for itself, or it can be set by some other process for an 
application (I don't remember the details of all the ways this can be set)

This could be used in a way similar to how userspace wakelocks are set 
today, if the power management process (that holds the wakelock and keep 
sthe screen lit today) thinks the system should be awake, let the 
jitter/fuzz be small, if that process thinks the system should probably be 
asleep, set the jitter/fuzz to a larger value. If other things are running 
anyway, the timers can fire and be serviced normally, otherwise the kernel 
is free to delay the timer going off even for badly written processes.

David Lang
--680960-54885766-1282259417=:8334--
