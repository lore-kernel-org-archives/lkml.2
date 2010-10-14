Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0JNUmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:42:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59064 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab0JNUmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:42:05 -0400
X-User-Agent: K-9 Mail for Android
References: <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com> <4CB65262.3070507@zytor.com> <alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com> <cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com> <alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com> <4CB688F4.9040706@zytor.com> <alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com> <4CB7240E.9000905@zytor.com> <AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com> <4CB7418C.7010505@zytor.com> <20101014183448.GA3187@elte.hu> <20101014123511.d628f873.akpm@linux-foundation.org>
In-Reply-To: <20101014123511.d628f873.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 14 Oct 2010 13:40:37 -0700
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <1bdcb8fa-d858-4a79-ae28-de8c94d13f5f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't like the CONFIG_EXPERT prefix, just because it makes it hard to move things into and out of this rubric, and that's bad... (consider: "oh, that would mean this *huge* patch) ... not to mention that what is CONFIG_EXPERT on one platform may not be for another!  As far as the main switch is concerned, it's a better name of course...

"Andrew Morton" <akpm@linux-foundation.org> wrote:

>On Thu, 14 Oct 2010 20:34:48 +0200
>Ingo Molnar <mingo@elte.hu> wrote:
>
>> 
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>> 
>> > On 10/14/2010 09:00 AM, Pekka Enberg wrote:
>> >
>> > >> CONFIG_EMBEDDED *is* "I am a user who (think I) know what I'm 
>> > >> doing". That is *what it is* and *all it is*.
>> > > 
>> > > Yup. The naming is quite unfortunate, though. Can we change it to 
>> > > something else?
>> > 
>> > Funny, this seems to come up repeatedly ;)
>> 
>> I'd suggest to rename CONFIG_EMBEDDED=y to CONFIG_EXPERT=y, but i'd also 
>> suggest to rename all sub-config-options that depend on CONFIG_EXPERT to 
>> have a CONFIG_EXPERT_ prefix.
>> 
>> So we'd have:
>> 
>>   CONFIG_EXPERT_CPU_SUP_INTEL=y
>>   CONFIG_EXPERT_MMAP_ALLOW_UNINITIALIZED=y
>> 
>> etc.
>
>yup.  CONFIG_EMBEDDED didn't make a lot of sense even when we first did it. 
>I suppose CONFIG_EXPERT is OK, although everyone will select it because
>they think they're experts ;)  CONFIG_PROPELLORHEAD!
>
>> That way all the enabled 'expert options' become easily visible in the 
>> .config file and they advertise themselves properly - it's also easily 
>> greppable. In the source code it also becomes self-documenting, it's 
>> obvious when a dependency is 'rare' or 'special' - it has a 
>> CONFIG_EXPERT_ prefix.
>> 
>> Something for the KS i guess.
>
>nah, just do it.

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
