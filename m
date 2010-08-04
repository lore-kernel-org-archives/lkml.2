Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0HDWnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:43:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:46747 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0HDWnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:43:50 -0400
Date: Wed, 4 Aug 2010 15:42:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Florian Mickler <florian@mickler.org>
cc: Pavel Machek <pavel@ucw.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100804233924.5303d19a@schatten.dmk.lab>
Message-ID: <alpine.DEB.2.00.1008041537450.6545@asgard.lang.hm>
References: <20100731230101.7cc1d8c7@infradead.org> <20100801191228.GL2470@linux.vnet.ibm.com> <20100801154708.19817b75@infradead.org> <20100802011006.GS2470@linux.vnet.ibm.com> <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
 <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com> <20100804163509.GA31523@srcf.ucam.org> <20100804204208.GA21452@elf.ucw.cz> <20100804205159.GH24163@linux.vnet.ibm.com> <20100804211513.GC21452@elf.ucw.cz>
 <20100804233924.5303d19a@schatten.dmk.lab>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Florian Mickler wrote:

> On Wed, 4 Aug 2010 23:15:13 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
>
>> Hi!
>>
>>>>>> If this doesn't work for the Android folks for whatever reason, another
>>>>>> approach would be to do the freeze in user code, which could track
>>>>>> whether any user-level resources (pthread mutexes, SysV semas, whatever)
>>>>>> where held, and do the freeze on a thread-by-thread basis within each
>>>>>> "victim" application as the threads reach safe points.
>>>>>
>>>>> The main problem I see with the cgroups solution is that it doesn't seem
>>>>> to do anything to handle avoiding loss of wakeup events.
>>>>
>>>> In different message, Arve said they are actually using low-power idle
>>>> to emulate suspend on Android.
>>>
>>> Hello, Pavel,
>>>
>>> Could you please point me at this message?
>>
>> AFAICT, this tells us that idle and suspend is the same hardware state
>> on current Android hardware:
>> 								Pavel
>>
>> Message-ID: <AANLkTinjH0C0bSK=Y2wKASnbJFsR2BN303xBXkaHbmRC@mail.gmail.com>
>>
>> Arve said:
>>
>> If you just program the alarm you will wake up see that the monotonic
>> clock has not advanced and set the alarm another n seconds into the
>> future. Or are proposing that suspend should be changed to keep the
>> monotonic clock running? If you are, why? We can enter the same
>> hardware states from idle, and modifying suspend to wake up more often
>> would increase the average power consumption in suspend, not improve
>> it for idle. In other words, if suspend wakes up as often as idle, why
>> use suspend?
>>
>>
>
> They always told us from the beginning, that on the msm platform they
> reach the same powerlevel from suspend and idle. They still get gains
> from using opportunistic suspend.

Yes, you will always get gains if you shutdown while there is still work 
to do.

the question I am raising is.

If, instead of doing opportunistic suspend (with wakelocks to keep things 
awake, requiring explicit application code changes to implement), how 
close would you be able to get if instead you just were able to tell the 
system to ignore some processes when considering if the system can sleep 
or not?

With badly written 'trusted' apps you will have poor power useage, but 
with badly written apps grabbing wakelocks inappropriately you will have 
poor power useage.

David Lang
