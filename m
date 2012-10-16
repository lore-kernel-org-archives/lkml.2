Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2JPTnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:43:19 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42120 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2JPTnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVKiO5t8AuEM=XxdPgZGr6crr6C-4174607_VLO787--g@mail.gmail.com>
References: <CAAZUjxCvK0QnwnZP_FBiO2JM1rMoEA3HLjKAcYD14cxdGWyg4Q@mail.gmail.com>
	<507DB47E.5090003@mit.edu>
	<CAAZUjxAPAUD50asniJVNgD3X=vM_d=GPKJ5C2eVGo6r4HUKYLQ@mail.gmail.com>
	<CALCETrVKiO5t8AuEM=XxdPgZGr6crr6C-4174607_VLO787--g@mail.gmail.com>
Date: Tue, 16 Oct 2012 14:43:14 -0500
Message-ID: <CAAZUjxD8-kA5325+OT0tANi0vUwcSRwT+VYaEd2LZ9cJrw0xUA@mail.gmail.com>
Subject: Re: VDSO gettimeofday() x86_64 linux 3.2
From: wilson self <wself00@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am just using gcc timetest.c -o timetest

Should be dynamically linked. glibc is 2.5, which is quite old, but I
think this should still work with it, no?

On Tue, Oct 16, 2012 at 2:39 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Oct 16, 2012 at 12:33 PM, wilson self <wself00@gmail.com> wrote:
>> current_clocksource is tsc.
>>
>> the entire source of the test application:
>> ---
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <sys/time.h>
>> #include <time.h>
>>
>> int main() {
>>       struct timeval tim;
>>       gettimeofday(&tim, NULL);
>>       printf("%.6lf seconds\n", tim.tv_sec+tim.tv_usec/1000000.0);
>> }
>> ---
>> nothing fancy going on here.
>>
>> thanks for the help.
>
> There's lots of hidden fanciness.  What glibc version are you using
> and how are you linking to glibc?  All but the newest glibc versions
> use the old vsyscall when statically linked.  The newest versions use
> the syscall instead.  If you're dynamically linking, then gettimeofday
> should be okay even with fairly old glibc versions.
>
> (FWIW, glibc maintainership has changed since this was decided.  Feel
> free to bug the new maintainers if you care about statically-linked
> performance.  The only other runtime library I know of that uses the
> vdso or vsyscalls is Go, and the newest versions do the right thing.)
>
> --Andy
