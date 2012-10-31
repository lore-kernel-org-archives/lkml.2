Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2JaANM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:13:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63404 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab2JaANK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:13:10 -0400
MIME-Version: 1.0
In-Reply-To: <20121030020500.GA2616@ZenIV.linux.org.uk>
References: <1351557682-20983-1-git-send-email-keescook@chromium.org>
	<1351557682-20983-3-git-send-email-keescook@chromium.org>
	<20121030020500.GA2616@ZenIV.linux.org.uk>
Date: Tue, 30 Oct 2012 17:13:07 -0700
X-Google-Sender-Auth: qJompI_bql0NgktydH0HwwrSrww
Message-ID: <CAGXu5j+quq5kJn3vxWRbSZVEDswcqRsXrPFz0EBRsOMfrWWXpA@mail.gmail.com>
Subject: Re: [PATCH 2/4] arch/arm: move secure_computing into trace
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Will Drewry <wad@chromium.org>,
        Geremy Condra <gcondra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 7:05 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Oct 29, 2012 at 05:41:20PM -0700, Kees Cook wrote:
>> From: Will Drewry <wad@chromium.org>
>>
>> There is very little difference in the TIF_SECCOMP and TIF_SYSCALL_TRACE
>> path in entry-common.S. In order to add support for
>> CONFIG_HAVE_ARCH_SECCOMP_FILTER without mangling the assembly too badly,
>> seccomp was moved into the syscall_trace_enter() handler.
>>
>> Additionally, the return value for secure_computing() is now checked
>> and a -1 value will result in the system call being skipped.
>
> This is too ugly.  Just expand the calls of ptrace_syscall_trace() into
> both callers and do secure_computing() hookup in there.  And for pity

So ad722541 didn't go far enough? It seems like it makes sense to
re-use the code in there.

> sake, would somebody rename the damn thing?  It's *dripping* with
> marketdroidese...

True, but that's been its name since seccomp mode 1. We could rename
it internally, but I think that would make more sense as a separate
patch set.

-Kees

-- 
Kees Cook
Chrome OS Security
