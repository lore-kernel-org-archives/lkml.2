Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0KZNun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:50:43 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46093 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0KZNum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:50:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Uh1io6AERjc+KMG9/7wWqM7GwV6y2nQN9Ue008AJ48jguMAwJtdNN73rzvKoN98k/B
         uwBoJivSYBYY9kdqJ4Q8DOefndg9CA87cO/gRhqoSb5wQpOl+seaFkEAyNb9VqiQWODF
         GvXQflq8eFAV7FUVoTrVJSaY8oOXk10D65AF4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikG9swqOxF2GwhvKY__Lbgt1+GgRfra-+DrBsk0@mail.gmail.com>
References: <20101123224601.766827604@openvz.org>
	<20101123224800.294919307@openvz.org>
	<AANLkTikjfM=8xa8smgT6D_WTYC_S-JZ69iiqu8gD21sK@mail.gmail.com>
	<AANLkTin1Q0eo4mFbSCeO4RNrK8Men0Q3r_x9_dCse11Q@mail.gmail.com>
	<AANLkTimOY=58aW0OsWhTRjc5tgxNApKpReNh0hwK7SJJ@mail.gmail.com>
	<AANLkTikWB0TbCO1JLCtk03HAV0qEj63fPZ+rzViAZJS4@mail.gmail.com>
	<AANLkTik1R-4kvoE81oqTrSm6RZdO005kL_xfbqfyrnFm@mail.gmail.com>
	<AANLkTi=1nxsKR2e9MAEzbPNt66TUD9Ltd+ug+C7Jhk+Y@mail.gmail.com>
	<AANLkTin63X+2pOuRYHF0ntnB95g-MWjug-sUYAFGFnxa@mail.gmail.com>
	<AANLkTikG9swqOxF2GwhvKY__Lbgt1+GgRfra-+DrBsk0@mail.gmail.com>
Date: Fri, 26 Nov 2010 16:50:40 +0300
X-Google-Sender-Auth: R3PjNost-E0XpppVViOKumkX-Og
Message-ID: <AANLkTi=jLNwKOqUKay9c9aLVd_7do5n1iCYEUkOfS7G+@mail.gmail.com>
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        ming.m.lin@intel.com, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 4:10 PM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Nov 26, 2010 at 2:04 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>> On 11/26/10, Stephane Eranian <eranian@google.com> wrote:
>>> On Fri, Nov 26, 2010 at 12:58 PM, Cyrill Gorcunov <gorcunov@openvz.org>
>>> wrote:
>>>> On 11/26/10, Stephane Eranian <eranian@google.com> wrote:
>>>>> On Fri, Nov 26, 2010 at 12:32 PM, Cyrill Gorcunov <gorcunov@openvz.org>
>>>>> wrote:
>>>>>> On Fri, Nov 26, 2010 at 2:14 PM, Cyrill Gorcunov <gorcunov@openvz.org>
>>>>>> wrote:
>>>>>>> Stephane, this is a misprint, I'll update this comments on format
>>>>>>> (giod catch btw!). in real low 32 bits are considered as cccr in ht
>>>>>>> mode. wait a bit, i'll post update.
>>>>>>>
>>>>>>> On 11/26/10, Stephane Eranian <eranian@google.com> wrote:
>>>>>> ...
>>>>>>>>> + *    Low 32 bits
>>>>>>>>> + *    -----------
>>>>>>>>> + *      0-6: P4_PEBS_METRIC enum
>>>>>>>>> + *     7-11:                    reserved
>>>>>>>>> + *       12: Active thread
>>>>>>>>
>>>>>>>> I don't understand bit 12. In the actual register, it
>>>>>>>> corresponds to the enable bit. Seems you're overriding
>>>>>>>> its usage. Do I interpret this as saying: 0 = enable when
>>>>>>>> running on thread0, 1=monitoring when running on thread1?
>>>>>>>> And if I don't care?
>>>>>> ...
>>>>>> I believe it simply escaped quilt refresh somehow. Here is the
>>>>>> 'refreshed'
>>>>>> copy (note the low bits 12-19 updated here).
>>>>>> ---
>>>>>> perf, x86: P4 PMU - describe config format v2
>>>>>>
>>>>>> Add description of .config in a sake of RAW events.
>>>>>> At least this should bring some light to those who
>>>>>> will be reading this code.
>>>>>>
>>>>>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>>>>>> CC: Lin Ming <ming.m.lin@intel.com>
>>>>>> CC: Stephane Eranian <eranian@google.com>
>>>>>> CC: Peter Zijlstra <peterz@infradead.org>
>>>>>> ---
>>>>>>  arch/x86/include/asm/perf_event_p4.h |   63
>>>>>> ++++++++++++++++++++++++++++++-----
>>>>>>  1 file changed, 55 insertions(+), 8 deletions(-)
>>>>>>
>>>>>> Index: linux-2.6.tip/arch/x86/include/asm/perf_event_p4.h
>>>>>> ===================================================================
>>>>>> --- linux-2.6.tip.orig/arch/x86/include/asm/perf_event_p4.h
>>>>>> +++ linux-2.6.tip/arch/x86/include/asm/perf_event_p4.h
>>>>>> @@ -744,14 +744,6 @@ enum P4_ESCR_EMASKS {
>>>>>>  };
>>>>>>
>>>>>>  /*
>>>>>> - * P4 PEBS specifics (Replay Event only)
>>>>>> - *
>>>>>> - * Format (bits):
>>>>>> - *   0-6: metric from P4_PEBS_METRIC enum
>>>>>> - *    7 : reserved
>>>>>> - *    8 : reserved
>>>>>> - * 9-11 : reserved
>>>>>> - *
>>>>>>  * Note we have UOP and PEBS bits reserved for now
>>>>>>  * just in case if we will need them once
>>>>>>  */
>>>>>> @@ -788,5 +780,60 @@ enum P4_PEBS_METRIC {
>>>>>>        P4_PEBS_METRIC__max
>>>>>>  };
>>>>>>
>>>>>> +/*
>>>>>> + * Notes on internal configuration of ESCR+CCCR tuples
>>>>>> + *
>>>>>> + * Since P4 has quite the different architecture of
>>>>>> + * performance registers in compare with "architectural"
>>>>>> + * once and we have on 64 bits to keep configuration
>>>>>> + * of performance event, the following trick is used.
>>>>>> + *
>>>>>> + * 1) Since both ESCR and CCCR registers have only low
>>>>>> + *    32 bits valuable, we pack them into a single 64 bit
>>>>>> + *    configuration. Low 32 bits of such config correspond
>>>>>> + *    to low 32 bits of CCCR register and high 32 bits
>>>>>> + *    correspond to low 32 bits of ESCR register.
>>>>>> + *
>>>>>> + * 2) The meaning of every bit of such config field can
>>>>>> + *    be found in Intel SDM but it should be noted that
>>>>>> + *    we "borrow" some reserved bits for own usage and
>>>>>> + *    clean them or set to a proper value when we do
>>>>>> + *    a real write to hardware registers.
>>>>>> + *
>>>>>> + * 3) The format of bits of config is the following
>>>>>> + *    and should be either 0 or set to some predefined
>>>>>> + *    values:
>>>>>> + *
>>>>>> + *    Low 32 bits
>>>>>> + *    -----------
>>>>>> + *      0-6: P4_PEBS_METRIC enum
>>>>>> + *     7-11:                    reserved
>>>>>> + *       12:                    reserved (Enable)
>>>>>> + *    13-15:                    reserved (ESCR select)
>>>>>> + *    16-17: Active Thread
>>>>>
>>>>> HW has the active thread bits reserved to 0x3.
>>>>> what about you? If not, then explain what they
>>>>> mean.
>>>>>
>>>> hm, not sure i follow, hw allows you to pass any of 4 values for that
>>>> field, so i simply pass it to kernel and then propagate to real cccr
>>>> register. if machine is not ht capable it might be a problem, but i
>>>> left it to a caller to set proper thread value here. i believe that
>>>> you read cccr spec for non-ht machine while ht machine has a bit more
>>>> flags to set.
>>>>
>>> You're right, I missed Figure-30.29. So you honor the field. The counter
>>> won't count anything if the task is not running on the corresponding
>>> HT thread, then.
>>
>> no ;) p4 treat this field in different meaning in compare to others
>> perf archs. the condition is not 'where' but 'when'. ie you can
>> specify 'when' to run counter: if none therad is active, single any
>> thread is active, both threads are active and finally any thread is
>> active (which is exactly 0b11 in single thread machine). i know it's
>> weird ;)
>>
> That is weird indeed.
>
> I can see this being somewhat useful in per-cpu mode. But this is
> weird in per-thread mode. That means you will count in your thread
> (OS and HW) only when the other HW thread runs. I am wondering
> about the security implications of this. I suspect you'd have to
> disallow this mode in per-thread mode.

No, single thread mode means _any_ single thread is running,
Stephane I'll describe some more a bit later (as only reach home),
ok?
