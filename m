Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1FGUMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:12:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33663 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab1FGUMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bE/u3DkOi9TJdfjp2x8Tg4Fo3jW/GEhRX2QoN1kYfMGyrabtNfcFQEd8xYXruTFCq/
         Mb0sqDsIJRLZ7EkEXIVTfd8AIWRIZ1Iuw1ZZtflsZ7w04qWSgCGsQ8TdZlnhYIRTGyIA
         bG8sGH1MGIj/V0lB/AQQtnOlGXyTUc2MQGgns=
MIME-Version: 1.0
In-Reply-To: <BANLkTincR0KUWA77+4Gzfm26-_W11ck1+Q@mail.gmail.com>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
 <1307373819.3098.40.camel@edumazet-laptop> <1307376672.2322.167.camel@twins>
 <1307376989.2322.171.camel@twins> <1307377349.3098.65.camel@edumazet-laptop>
 <1307377782.2322.183.camel@twins> <1307378564.3098.67.camel@edumazet-laptop>
 <4DED1421.5000300@linux.intel.com> <1307383898.3098.90.camel@edumazet-laptop>
 <4DED976C.90009@linux.intel.com> <4DEE3944.5020005@mit.edu>
 <1307462300.3091.39.camel@edumazet-laptop> <BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>
 <BANLkTinHEyRnnJqB=GTwBOAb6aRaHnjQLQ@mail.gmail.com> <BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>
 <BANLkTi=KZcosEZ9_WEjQw7fZRwzBeR67yA@mail.gmail.com> <BANLkTikM5M=ezSPg2p5=N5rGzC84Ca1+cQ@mail.gmail.com>
 <BANLkTincR0KUWA77+4Gzfm26-_W11ck1+Q@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 7 Jun 2011 16:12:28 -0400
X-Google-Sender-Auth: od-viPXAp9nVt7y6sgz5-Wp1Qaw
Message-ID: <BANLkTinS-c2Z=LD_tJfVCEqkMaAd4KPgwg@mail.gmail.com>
Subject: Re: Change in functionality of futex() system call.
To: David Oliver <david@rgmadvisors.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 4:04 PM, David Oliver <david@rgmadvisors.com> wrote:
> On Tue, Jun 7, 2011 at 2:53 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Tue, Jun 7, 2011 at 3:33 PM, David Oliver <david@rgmadvisors.com> wrote:
>>> On Tue, Jun 7, 2011 at 2:19 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>> On Tue, Jun 7, 2011 at 3:10 PM, David Oliver <david@rgmadvisors.com> wrote:
>>>>> On Tue, Jun 7, 2011 at 1:43 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>>>> On Tue, Jun 7, 2011 at 11:58 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>>>> Le mardi 07 juin 2011 à 10:44 -0400, Andy Lutomirski a écrit :
>>>>>>>> On 06/06/2011 11:13 PM, Darren Hart wrote:
>>>>>>>> >
>>>>>>>> >
>>>>>>>> > On 06/06/2011 11:11 AM, Eric Dumazet wrote:
>>>>>>>> >> Le lundi 06 juin 2011 à 10:53 -0700, Darren Hart a écrit :
>>>>>>>> >>>
>>>>>>>> >>
>>>>>>>> >>> If I understand the problem correctly, RO private mapping really doesn't
>>>>>>>> >>> make any sense and we should probably explicitly not support it, while
>>>>>>>> >>> special casing the RO shared mapping in support of David's scenario.
>>>>>>>> >>>
>>>>>>>> >>
>>>>>>>> >> We supported them in 2.6.18 kernels, apparently. This might sounds
>>>>>>>> >> stupid but who knows ?
>>>>>>>> >
>>>>>>>> >
>>>>>>>> > I guess this is actually the key point we need to agree on to provide a
>>>>>>>> > solution. This particular case "worked" in 2.6.18 kernels, but that
>>>>>>>> > doesn't necessarily mean it was supported, or even intentional.
>>>>>>>> >
>>>>>>>> > It sounds to me that we agree that we should support RO shared mappings.
>>>>>>>> > The question remains about whether we should introduce deliberate
>>>>>>>> > support of RO private mappings, and if so, if the forced COW approach is
>>>>>>>> > appropriate or not.
>>>>>>>> >
>>>>>>>>
>>>>>>>> I disagree.
>>>>>>>>
>>>>>>>> FUTEX_WAIT has side-effects.  Specifically, it eats one wakeup sent by
>>>>>>>> FUTEX_WAKE.  So if something uses futexes on a file mapping, then a
>>>>>>>> process with only read access could (if the semantics were changed) DoS
>>>>>>>> the other processes by spawning a bunch of threads and FUTEX_WAITing
>>>>>>>> from each of them.
>>>>>>>>
>>>>>>>> If there were a FUTEX_WAIT_NOCONSUME that did not consume a wakeup and
>>>>>>>> worked on RO mappings, I would drop my objection.
>>>>>>>
>>>>>>> If a group of cooperating processes uses a memory segment to exchange
>>>>>>> critical information, do you really think this memory segment will be
>>>>>>> readable by other unrelated processes on the machine ?
>>>>>>
>>>>>> Depends on the design.
>>>>>>
>>>>>> I have some software I'm working on that uses shared files and could
>>>>>> easily use futexes.
>>>>>>
>>>>> I have software which currently uses shared files for a one way
>>>>> transfer of information, which is modeled precisely by the futex (as
>>>>> contrasted to the mutex) model. In this case, the number of receivers
>>>>> is undetermined, so the number of wakeups is set to maxint.
>>>>>
>>>>> The receivers are minimally trusted: they have read access to the
>>>>> files, so they cannot accidentally affect other processes use of the
>>>>> data. Requiring my files to be writeable by all clients would require
>>>>> a serious increase in the amount of software needing to be trusted.
>>>>
>>>> What's wrong with adding a FUTEX_WAIT_NOCONSUME flag then?  Your
>>>> program can use it to get exactly the semantics it wants and my
>>>> program can use it or not depending on which semantics it wants.
>>>>
>>> 1. I would prefer not to require my programs have to check for kernel
>>> version (code named "working", "regressed", and "altered") to decide
>>> which parameters need to be sent to the futex call.
>>
>> You don't have to check for kernel version.  Just try
>> FUTEX_WAIT_NOCONSUME first and retry with FUTEX_WAIT if it returns
>> -EINVAL.
>>
> ... and punt if that gives me an EFAULT. Possible but clumsy.
> Fortunately, I'm not writing code for general consumption.
>
>> I think you've already lost on regressed kernels regardless :-/
>>
>>> 2. Doing FUTEX_WAIT_NOCONSUME would change the semantics of
>>> futex_wake() between the "working" and "altered" kernels, as it would
>>> no longer return the number of processes woken.
>>
>> True, but that change couldn't affect old code because old code
>> wouldn't use FUTEX_WAIT_NOCONSUME.
>>
> So, how would I find out the number of processes awakened by the
> futex_wake() - I only care for statistical purposes.

Add a FUTEX_WAKE_COUNT_NOCONSUME or some such magic flag.  Yeah, not so pretty.

>
>>>
>>> It seems that FUTEX_WAIT_NOCONSUME would be rather like a
>>> non-consuming read on a pipe.
>>
>> More like a nonconsuming read on an eventfd, which sounds very useful.
>>  (Actually, I'm porting code from Windows to Linux right now that
>> wants that feature...)
>>
>> The reason I bring this up now is that I've been annoyed that
>> FUTEX_WAIT can be used on an R/O mapping to interfere with futexes in
>> that mapping.  Under the original semantics this would have been
>> pretty much impossible to fix, but the regression has been there for
>> long enough that we have the option right now to fix it better instead
>> of restoring the original behavior.
>>
> Not being a kernel developer, the change seems very recent - about
> when I started finding my code failing with EFAULTs.
>
> From my perspective, that's a real case of my futexes being interfered with :).

Fair enough.  But it's a little late to prevent the regression.

--Andy
