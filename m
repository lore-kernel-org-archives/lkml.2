Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2C0SBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:01:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42425 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2C0SBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:01:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120327173744.GD10142@thunk.org>
References: <CAGXu5jK3ezCN2=hy=AARh=T9L8YzCTKAXH6dbAH7FGX3P8VkoQ@mail.gmail.com>
	<20120327172133.GB10142@thunk.org>
	<CAGXu5jJx85b2ysgx2aXWUUf4dJMc34Cukp3S1VKiC_Pc5U2+Pw@mail.gmail.com>
	<20120327173744.GD10142@thunk.org>
Date: Tue, 27 Mar 2012 11:01:29 -0700
Message-ID: <CAGXu5j+itrR6cCWpXZAA0ZEP2KhdHdhcYA-R6pc=B97a_rHbaQ@mail.gmail.com>
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

On Tue, Mar 27, 2012 at 10:37 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Mar 27, 2012 at 10:29:39AM -0700, Kees Cook wrote:
>>
>> I'm trying to get at the future seccomp fields on siginfo_t, namely
>> "si_syscall":
>
> Ah, I didn't realize you were trying to do that.  siginfo_t has been
> stable since forever, and so I think we've always depending on glibc
> to export the structure.  As a result I don't know that much effort
> has been made to make siginfo.h safe for any userspace user other than
> glibc.
>
> Silly question; we're not going to actually change the size of the
> siginfo_t structure in a userspace visible way, are we?  I don't know
> of are any shared libraries that fill in a siginfo_t structure passed
> in by the caller (which could be located on the stack), but it's
> certainly possible that such library ABI's could exist.

No, siginfo, IIUC, is defined to be SI_MAX_SIZE bytes. The union for
seccomp (on SIGSYS) just uses a long and 2 ints. It'd be nice for
there to be a stable way to get the kernel's siginfo instead of
glibc's.

-Kees

-- 
Kees Cook
Chrome OS Security
