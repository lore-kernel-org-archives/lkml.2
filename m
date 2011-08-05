Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1HEVBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:01:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64541 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1HEVBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:01:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110805205222.GK5782@one.firstfloor.org>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
 <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
 <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 5 Aug 2011 17:00:44 -0400
X-Google-Sender-Auth: fmTgL-znIUIeqd-kVSHjGv5VHEQ
Message-ID: <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com>
Subject: Re: New vsyscall emulation breaks JITs
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 4:52 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Fri, Aug 05, 2011 at 01:48:28PM -0700, H. Peter Anvin wrote:
>> On 08/05/2011 01:45 PM, Andrew Lutomirski wrote:
>> >
>> > hpa: time is supported (as of 3.0) by the vdso, and very new glibc
>> > uses the vdso version.  We could add a native time implementation back
>> > to the vsyscall page without too much pain as a short-term fix, but
>> > that would be less than ideal.
>> >
>>
>> How new does glibc have to be?
>
> Mine from May 17 doesn't support it.

c738465a4c13370f58b797a82cdf1c67e1121867 from May 28.

>
>> How much of a pain would it be to make the legacy vs emulated vsyscall
>> page a config option?
>
> CONFIG_DONT_BREAK_MY_BINARIES?
>

If gettimeofday could be a pure syscall fallback, then it wouldn't be
so bad.  With the vread_tsc changes, the vsyscall page can't directly
call ->vread anymore, and making *that* conditional would be rather
ugly.

> If anything runtime, but really for me it looks like the vsyscall
> changes should be only in one of those limited compability paranoia
> patchkits.

Switching it in runtime would be a giant mess because user code might
be executing from the vsyscall page while we try to switch it.
Switching at boot time might not be so bad.  We'd just compile the
emulation code in unconditionally but have a fallback page that we
could map if needed.

I also filed this issue:
https://code.google.com/p/dynamorio/issues/detail?id=530

--Andy
