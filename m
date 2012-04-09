Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2DITcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:32:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35709 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab2DITcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <CABqD9hZVZQXA5cyufwWirWVUYZwSkjRxHR2CBKW5V62qD-DGtA@mail.gmail.com>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-10-git-send-email-wad@chromium.org>
	<20120406141415.93f46bc6.akpm@linux-foundation.org>
	<CABqD9hZVZQXA5cyufwWirWVUYZwSkjRxHR2CBKW5V62qD-DGtA@mail.gmail.com>
Date: Mon, 9 Apr 2012 12:32:05 -0700
X-Google-Sender-Auth: CdtvUXCKDw8TljGF9YMPdroEquk
Message-ID: <CAGXu5jLSE72eX+rxnfyXdp=VvUi+gqy1apT9QcdA4ADM-H0awA@mail.gmail.com>
Subject: Re: [PATCH v17 09/15] seccomp: remove duplicated failure logging
From: Kees Cook <keescook@chromium.org>
To: Will Drewry <wad@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 12:26 PM, Will Drewry <wad@chromium.org> wrote:
> On Fri, Apr 6, 2012 at 4:14 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Thu, 29 Mar 2012 15:01:54 -0500
>> Will Drewry <wad@chromium.org> wrote:
>>
>>> From: Kees Cook <keescook@chromium.org>
>>>
>>> This consolidates the seccomp filter error logging path and adds more
>>> details to the audit log.
>>>
>>> ...
>>>
>>> -void __audit_seccomp(unsigned long syscall)
>>> +void __audit_seccomp(unsigned long syscall, long signr, int code)
>>>  {
>>>       struct audit_buffer *ab;
>>>
>>>       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
>>> -     audit_log_abend(ab, "seccomp", SIGKILL);
>>> +     audit_log_abend(ab, "seccomp", signr);
>>>       audit_log_format(ab, " syscall=%ld", syscall);
>>> +#ifdef CONFIG_COMPAT
>>> +     audit_log_format(ab, " compat=%d", is_compat_task());
>>> +#endif
>>
>> We don't need the ifdef for compilation reasons now.
>>
>> The question is: should we emit the compat= record on
>> non-compat-capable architectures?  Doing so would be safer - making it
>> conditional invites people to write x86-only usersapce.
>
> I'd certainly prefer it always being there for exactly that reason.
>
> Kees, Eric, any preferences?  Unless I hear one, I'll just drop the
> ifdefs in the next revision.

Yeah, I'd prefer the ifdefs dropped too.

-Kees

-- 
Kees Cook
ChromeOS Security
