Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1BBKvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:51:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab1BBKvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:51:32 -0500
Message-ID: <4D493725.402@redhat.com>
Date: Wed, 02 Feb 2011 12:51:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 3/6] KVM-GST: KVM Steal time accounting
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>	 <1296244340-15173-4-git-send-email-glommer@redhat.com>	 <4D456FF9.2010309@redhat.com> <1296575824.5081.17.camel@mothafucka.localdomain> <4D492DBA.9050603@redhat.com>
In-Reply-To: <4D492DBA.9050603@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 12:11 PM, Avi Kivity wrote:
> On 02/01/2011 05:57 PM, Glauber Costa wrote:
>> On Sun, 2011-01-30 at 16:04 +0200, Avi Kivity wrote:
>> >  On 01/28/2011 09:52 PM, Glauber Costa wrote:
>> > >  This patch accounts steal time time in kernel/sched.
>> > >  I kept it from last proposal, because I still see advantages
>> > >  in it: Doing it here will give us easier access from scheduler
>> > >  variables such as the cpu rq. The next patch shows an example of
>> > >  usage for it.
>> > >
>> > >  Since functions like account_idle_time() can be called from
>> > >  multiple places, not only account_process_tick(), steal time
>> > >  grabbing is repeated in each account function separatedely.
>> > >
>> >
>> >  I accept that steal time is worthwhile, but do you have some way to
>> >  demonstrate that the implementation actually works and is beneficial?
>> >
>> >  Perhaps run two cpu-bound compute processes on one vcpu, 
>> overcommit that
>> >  vcpu, and see what happens to the processing rate with and without 
>> steal
>> >  time accounting.  I'd expect a fairer response with steal time 
>> accounting.
>>
>> Avi,
>>
>> There are two things here:
>> One of them, which is solely the accounting of steal time, (patches 1 to
>> 4) has absolutely nothing to do with what you said. Its sole purpose is
>> to provide the user with information about "why is my process slow if I
>> am using 100 % of my cpu?")
>
> Right.  Like irq and softirq time, we need to report this to the user, 
> as it's potentially much higher.

Of course, it's not enough to just account for this time, you also have 
to expose it somewhere, and update tools like top(1) to display it.

-- 
error compiling committee.c: too many arguments to function

