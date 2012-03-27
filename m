Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2C0R3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:29:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54707 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2C0R3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120327172133.GB10142@thunk.org>
References: <CAGXu5jK3ezCN2=hy=AARh=T9L8YzCTKAXH6dbAH7FGX3P8VkoQ@mail.gmail.com>
	<20120327172133.GB10142@thunk.org>
Date: Tue, 27 Mar 2012 10:29:39 -0700
Message-ID: <CAGXu5jJx85b2ysgx2aXWUUf4dJMc34Cukp3S1VKiC_Pc5U2+Pw@mail.gmail.com>
Subject: Re: Correct way to include siginfo.h?
From: Kees Cook <keescook@google.com>
To: "Ted Ts'o" <tytso@mit.edu>, Kees Cook <keescook@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 10:21 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Mar 27, 2012 at 10:01:10AM -0700, Kees Cook wrote:
>>
>> Does anyone know the right way to include siginfo.h when building
>> userspace tools that need it?
>
> What fields or structures are you trying to get at?  I haven't needed
> to include siginfo.h explicitly even though this file pokes and prods
> pretty thoroughly at the siginfo structures:

I'm trying to get at the future seccomp fields on siginfo_t, namely
"si_syscall":

static void reporter(int nr, siginfo_t *info, void *void_context)
{
...
    syscall = info->si_syscall;

> http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob;f=e2fsck/sigcatcher.c;h=10b93287d5b2b4da1fb43d34fafd848d06c01645;hb=5f7c04972fefa8198c34f231a9e8a5430705b4ab
>
> The sigcatcher.c file is a debugging tool for e2fsprogs that prints
> pretty much everything that is available to userspace, as far as I
> know...

Yeah, it looks like you're leaning on glibc's signal.h (and its
bits/signal.h file), which has its own siginfo definition rather than
attempting to include one from the kernel.

-Kees

-- 
Kees Cook
Chrome OS Security
