Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2EFSsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 14:48:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35409 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab2EFSsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 14:48:35 -0400
References: <20120506162000.GT6871@ZenIV.linux.org.uk> <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com> <20120506175451.GU6871@ZenIV.linux.org.uk> <4FA6BBD9.3040308@zytor.com> <20120506184641.GW6871@ZenIV.linux.org.uk>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120506184641.GW6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 06 May 2012 11:48:15 -0700
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Message-ID: <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would argue Sparc is not correct here but I am not a Sparc expert.

Al Viro <viro@ZenIV.linux.org.uk> wrote:

>On Sun, May 06, 2012 at 10:58:49AM -0700, H. Peter Anvin wrote:
>
>> > What kind of semantics do we want?  "Thread property" one, set when
>we
>> > set personality on execve(), or "syscall property", like e.g. x86
>TIF_IRET
>> > and TS_COMPAT?
>> 
>> It depends on the ABI properties of the platform.  The x86 compat ABI
>is
>> that any task can issue a compat ABI request and get a compat ABI
>> response (a 64-bit task can call int $0x80 for an ia32 syscall
>> invocation, or use syscall with either an x86-64 or and x32 system
>call
>> number.)  So is_compat_task() returns the current system call mode of
>> the task, because that is what downstream users need.  One of the
>> biggest users is the input subsystem, which earns the black mark for
>> worst possible ABI design, and that definitely depends on the system
>> call type being invoked.
>
>Umm...  Let me restate that question: is there ever a case when it
>would
>_not_ be a syscall property?  I.e. when both 64bit and 32bit syscalls
>are
>possible for a given process *and* callers of is_compat_task() care
>about
>the kind of process and not the kind of syscall?
>
>Is e.g. sparc behaviour ("what kind of process it is, regardless of
>whether
>we are issuing a 32bit or a 64bit syscall") correct?
>
>Sure, on a platform where the possible kind of syscall is a function of
>process' personality, a thread property can be a used to tell which
>kind of syscall we are in.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
