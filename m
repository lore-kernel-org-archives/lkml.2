Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1HQFOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 01:14:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51550 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1HQFOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 01:14:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110816153938.GA20428@redhat.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAF8ieYU2ThME1Q3u6xOp0sVOh-dPep-874TDY-=-q9E3OiSQAg@mail.gmail.com>
	<1312799149.10579.109.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAF8ieYV_3skMFo4Mc59hX1g1tFEjg8Fjnag36ZQwU9w=CPkLLQ@mail.gmail.com>
	<1313488648.3436.126.camel@mfleming-mobl1.ger.corp.intel.com>
	<20110816153938.GA20428@redhat.com>
Date: Tue, 16 Aug 2011 22:14:16 -0700
Message-ID: <CAF8ieYW+VC8kp10zuo8EpXXVB3vyLwGODSYFiK1xw25Z=pJMPw@mail.gmail.com>
Subject: Re: avr32: handle_signal() bug?
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 8:39 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/16, Matt Fleming wrote:
>> Maybe try
>> adding a clear_thread_flag(TIF_RESTORE_SIGMASK); to the success path in
>> handle_signal() and see if you get better results?
>
> I will be surprised if this helps with this particular test-case,
> but I agree this should be fixed anyway.

Yeah, we should get that fixed.

>> > Your patch doesn't appear to do any harm though, and it looks correct
>> > to me. Perhaps there's another bug lurking somewhere as well. Some
>> > preliminary debugging makes me suspicious about libc, but I can't tell
>> > for sure yet.
>>
>> Which libc is this by the way?
>
> may be you can run the test-case under strace? On my machine
> strace -f -e rt_sigprocmask ./test shows
>
>        [pid 25610] --- SIGUSR1 (User defined signal 1) @ 0 (0) ---
>        [pid 25610] rt_sigprocmask(SIG_BLOCK, NULL, [USR2 TERM], 8) = 0

Hmm, doing that makes my board reboot. I guess we're having trouble
with ptrace() as well...somehow the pid parameter to kill() gets
turned into 1 when running under strace, and it just so happens that
busybox's init interprets SIGUSR1 as "halt".

kill(1, SIGUSR1)                        = 0

Oh well, perhaps it's time to finally get those tracehooks implemented.

For now, please feel free to add

Acked-by: Havard Skinnemoen <hskinnemoen@gmail.com>

to the two patches Matt sent earlier. I think they move things in the
right direction even though there are other issues that need to be
fixed as well.

Havard
