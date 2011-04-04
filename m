Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1DDNCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:02:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46759 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1DDNCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimTMTaUko92O2aFhabJSNrnsOuO4g@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
	<AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
	<AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
	<alpine.LSU.2.00.1103182158200.18771@sister.anvils>
	<BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
	<AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
	<BANLkTim3x=1n+F7yD-euY0=RhmyXViUamg@mail.gmail.com>
	<AANLkTik4q8N9vYUibSZfepUmhYoREo2dbH5NFZAHuOFb@mail.gmail.com>
	<BANLkTimTMTaUko92O2aFhabJSNrnsOuO4g@mail.gmail.com>
Date: Mon, 4 Apr 2011 15:02:08 +0200
Message-ID: <BANLkTiknhQit+kdACxLVs-+TPGKY2iuvFw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Hui Zhu <teawater@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 2, 2011 at 6:01 AM, Hui Zhu <teawater@gmail.com> wrote:
> On Sat, Apr 2, 2011 at 00:35, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Fri, Apr 1, 2011 at 9:21 AM, Robert Święcki <robert@swiecki.net> wrote:
>>>
>>> Is it possible to turn it off via config flags? Looking into
>>> arch/x86/include/asm/bug.h it seems it's unconditional (as in "it
>>> always manifests itself somehow") and I have
>>> CONFIG_DEBUG_BUGVERBOSE=y.
>>
>> Ok, if you have CONFIG_DEBUG_BUGVERBOSE then, you do have the bug-table.
>>
>> Maybe it's just kdb that is broken, and doesn't print it. I wouldn't
>> be surprised. It's not the first time I've seen debugging features
>> that just make debugging a mess.
>>
>>> Anything that could help you debugging this? Uploading kernel image
>>> (unfortunately I've overwritten this one), dumping more kgdb data?
>>
>> So in this case kgdb just dropped the most important data on the floor.
>>
>> But if you have kdb active next time, print out the vma/old contents
>> in that function that has the BUG() in it.
>>
>>> I must admit I'm not up-to-date with current linux kernel debugging
>>> techniques. The kernel config is here:
>>> http://alt.swiecki.net/linux_kernel/ise-test-2.6.38-kernel-config.txt
>>>
>>> For now I'll compile with -O0 -fno-inline (are you sure you'd like -Os?)
>
> Hi Robert,
>
> I am not sure you can success with build trunk with  -O0 -fno-inline.
> I suggest you try the patch in
> http://code.google.com/p/kgtp/downloads/detail?name=co.patch.
> It add a option in "Kernel hacking" called "Compile with almost no
> optimization". It will make kernel be built without -O2. It support
> x86_32, x86_64 and arm.

HI,

Yeah.. -O0 doesn't build smoothly, it seems that building with -O0 is
not required right now, but I'll keep your patch in mind in case it
becomes necessary. Thanks for the tip.

> PS, maybe you can try kgtp (https://code.google.com/p/kgtp/)  debug your kernel.
>
>>
>> Oh, don't do that. -O0 makes the code totally unreadable (the compiler
>> just does _stupid_ things, making the asm code look so horrible that
>> you can't match it up against anything sane), and -fno-inline isn't
>> worth the pain either.
>>
>> -Os is much better than those.
>>
>> But in this case, just getting the filename and line number would have
>> made the thing moot anyway - without kdb it _should_ have said
>> something clear like
>>
>>   kernel BUG at %s:%u!
>>
>> where %s:%u is the filename and line number.
>>
>>                          Linus
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>



-- 
Robert Święcki
