Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1HJWWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 18:22:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46400 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab1HJWWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 18:22:31 -0400
References: <cover.1312988155.git.luto@mit.edu> <8449fb3abf89851fd6b2260972666a6f82542284.1312988155.git.luto@mit.edu> <4E42BDFF.5060507@zytor.com> <CAObL_7Ge7PDSqt8sfBAODDnuA34oCsA4Lat24RXGe1DPAKdXqA@mail.gmail.com> <ad7e51af-a4cf-4b30-972f-8704ef748d24@email.android.com> <CAObL_7HO_6krk86GQuqt3o4aqjkp3CMbQ1s2P9L5bU0R0m8Hpg@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAObL_7HO_6krk86GQuqt3o4aqjkp3CMbQ1s2P9L5bU0R0m8Hpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/3] x86-64: Rework vsyscall emulation and add vsyscall= parameter
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 10 Aug 2011 17:20:58 -0500
To: Andrew Lutomirski <luto@mit.edu>
CC: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>
Message-ID: <4b8d6929-6163-4e25-933c-c875a1857f3a@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lutomirski <luto@mit.edu> wrote:

>On Wed, Aug 10, 2011 at 5:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Andrew Lutomirski <luto@mit.edu> wrote:
>>
>>>On Wed, Aug 10, 2011 at 1:21 PM, H. Peter Anvin <hpa@zytor.com>
>wrote:
>>>> On 08/10/2011 10:15 AM, Andy Lutomirski wrote:
>>>>> There are three choices:
>>>>>
>>>>> vsyscall=native: Vsyscalls are native code that issues the
>>>>> corresponding syscalls.
>>>>>
>>>>> vsyscall=emulate (default): Vsyscalls are emulated by instruction
>>>>> fault traps, tested in the bad_area path.  The actual contents of
>>>>> the vsyscall page is the same as the vsyscall=native case except
>>>>> that it's marked NX.  This way programs that make assumptions
>about
>>>>> what the code in the page does will not be confused when they read
>>>>> that code.
>>>>>
>>>>> vsyscall=none: Trying to execute a vsyscall will segfault.
>>>>>
>>>>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>>>>
>>>> Hi Andy,
>>>>
>>>> This patch doesn't apply.  What is your baseline for this patch?
>>>
>>>My baseline was a commit that probably only lives in my tree, but the
>>>patches should apply cleanly on top of
>>>c149a665ac488e0dac22a42287f45ad1bda06ff1, which is the current
>>>tip/x86/vdso.
>>>
>>>--Andy
>>
>> Please rebase your patch on the current -linus since it appears to
>have changed since x86/vdso was merged.
>>
>
>Can you double-check?  I think it's the other way around: x86/vdso has
>fixes that should be pushed to Linus.
>
>$ git log tip/x86/vdso ^origin/master --oneline
>c149a66 x86-64: Add vsyscall:emulate_vsyscall trace event
>318f5a2 x86-64: Add user_64bit_mode paravirt op
>5d5791a x86-64, xen: Enable the vvar mapping
>f670bb7 x86-64: Work around gold bug 13023
>9c40818 x86-64: Move the "user" vsyscall segment out of the data
>segment.
>1bdfac1 x86-64: Pad vDSO to a page boundary
>17b0436 Merge commit 'v3.0' into x86/vdso
>
>--Andy

You're right, although coupling it makes the testing harder.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
