Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1IDTbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 15:31:38 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:61882 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1IDTb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 15:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <1914350.DTEPrFeNfA@wuerfel>
References: <4E582577.2060805@zytor.com>
	<3546423.kFMPx0aPCi@wuerfel>
	<CAMe9rOqJoy=S4-=tZXrti7w_GtSqaTgX9i69FR92Tv6pPfSDRQ@mail.gmail.com>
	<1914350.DTEPrFeNfA@wuerfel>
Date: Sun, 4 Sep 2011 12:31:25 -0700
Message-ID: <CAMe9rOofkcOarfWE1PcHcgLwM+hKdTkXZZr4e_n3v-Avb+bN=g@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 4, 2011 at 12:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 04 September 2011 11:40:39 H.J. Lu wrote:
>> #define __NR_x32_rt_sigaction
>> #define __NR_x32_rt_sigprocmask
>> #define __NR_x32_rt_sigreturn
>> #define __NR_x32_rt_sigpending
>> #define __NR_x32_rt_sigtimedwait
>> #define __NR_x32_rt_sigqueueinfo
>> #define __NR_x32_rt_tgsigqueueinfo
>> #define __NR_x32_sigaltstack
>> #define __NR_x32_waitid
>> #define __NR_x32_mq_notify
>> #define __NR_x32_timer_create
>
> Right, all signal functions certainly need a new implementation.

We only need to add stub_x32_rt_sigreturn, stub_x32_execve,
stub_x32_sigaltstack and stub_x32_sigaltstack   The rest use
x86-32 system calls.

>> #define __NR_x32_ioctl
>
> What do you plan to do for ioctl? Does this mean you want to
> have a third file_operations pointer besides ioctl and compat_ioctl?
> I would hope that you manage this by using different ioctl command
> numbers in the few cases where the x32 version has to differ from
> the x86-32 data structure.

This requires some kernel changes since x32 has 32bit pointers and 64bit
time_t/timespec/timeval.   We can't use straight x86-32 nor x86-64.

>> #define __NR_x32_readv
>> #define __NR_x32_writev
>> #define __NR_x32_preadv
>> #define __NR_x32_pwritev
>> #define __NR_x32_vmsplice
>> #define __NR_x32_move_pages
>> #define __NR_x32_execve
>> #define __NR_x32_set_robust_list
>> #define __NR_x32_get_robust_list
>> #define __NR_x32__sysctl
>> #define __NR_x32_kexec_load
>> #define __NR_x32_times
>
> I guess you could define the x32 iovec etc. to be compatible with the
> 64 bit one, but that's not a major thing. Why can't you use the
> regular x86_32 calls here?

I am using the regular  x86_32 calls for them.

>
>> #define __NR_x32_recvfrom
>> #define __NR_x32_sendmsg
>> #define __NR_x32_recvmsg
>> #define __NR_x32_recvmmsg
>> #define __NR_x32_sendmmsg
>
> These today use the MSG_CMSG_COMPAT flag to distinguish native and compat
> calls. Do you plan to have another flag here to handle cmsg time values?

I am using x86-32 calls for them.

> What about things like mq_{get,set}attr, quotactl and semtimedop?
>

I am using 64bit system calls for x32.

-- 
H.J.
