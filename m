Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1HAMaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:30:10 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50653 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab1HAMaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110731110119.GO5404@dastard>
References: <20110729013830.GC5404@dastard> <CAObL_7GdxD07-9_aYZBDqutQD6cVz2kYHXAcUwDWr6NkqRdByw@mail.gmail.com>
 <20110729072426.GF5404@dastard> <CAObL_7HCyS0aE2KKJR0rF48VKVqdeOruNVvsakAjzR5J6GHvPw@mail.gmail.com>
 <CAObL_7G6rb23X2xAA0Aw6jT+TapynDvhAicNNeo91jD09S5UkQ@mail.gmail.com> <20110731110119.GO5404@dastard>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 1 Aug 2011 08:29:47 -0400
X-Google-Sender-Auth: LLYgSiWmi9NqVSVKiL-lzd49C8U
Message-ID: <CAObL_7ES3FyAAaX-1GOjKV1xCbT2pnW7=Ey+=ErUdTKUt8shkA@mail.gmail.com>
Subject: Re: [3.0-rc0 Regression]: legacy vsyscall emulation increases user
 CPU time by 20%
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 7:01 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jul 29, 2011 at 09:26:19AM -0400, Andrew Lutomirski wrote:
>> On Fri, Jul 29, 2011 at 8:17 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>> > On Fri, Jul 29, 2011 at 3:24 AM, Dave Chinner <david@fromorbit.com> wrote:
>> >> On Thu, Jul 28, 2011 at 11:30:49PM -0400, Andrew Lutomirski wrote:
>> >>> >
>> >>> > Assuming this is the problem, can this be fixed without requiring
>> >>> > the whole world having to wait for the current glibc dev tree to
>> >>> > filter down into distro repositories?
>> >>>
>> >>> How old is your glibc?  gettimeofday has used the vdso since:
>> >>
>> >> It's 2.11 on the test machine, whatever that translates to. I
>> >> haven't really changed the base userspace for about 12 months
>> >> because if I do I invalidate all my historical benchmark results
>> >> that I use for comparisons.
>> >
>> > 2.11 is from 2009 and appears to contain that commit.  Does your
>> > workload call time() very frequently?  That's the largest slowdown.
>> > With the old code, time() took 4-5 ns and with the new code time() is
>> > about as slow as gettimeofday().  I suggested having a config option
>> > to allow time() to stay fast until glibc 2.14 became widespread, but a
>> > few other people disagreed.
>>
>> *sigh*
>>
>> fs_mark: fs_mark.o lib_timing.o
>>         ${CC} -static -o fs_mark fs_mark.o lib_timing.o
>>
>> Even brand-new glibc still issues vsyscalls when statically linked,
>> and Ulrich has said [1] that he doesn't care that much about
>> performance of statically linked code.
>>
>> How bad would it be to just remove the -static from the makefile?
>
> Results in 270s +-5s user CPU time, so user CPU time is still ~10%
> up on 3.0 numbers.  IOWs, a non-static link roughly halves the
> regression but doesn't get rid of it.

Are you sure?  I stuck a trace event in do_emulate_vsyscall and it's
not getting hit at all in fs_mark, at least on my system.  I'll send
out the patch tomorrow.

--Andy
