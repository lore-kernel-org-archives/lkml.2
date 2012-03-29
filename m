Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638Ab2C2SNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:13:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52526 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab2C2SNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <4F74A2C9.1000009@zytor.com>
References: <CAGXu5jK3ezCN2=hy=AARh=T9L8YzCTKAXH6dbAH7FGX3P8VkoQ@mail.gmail.com>
	<20120327172133.GB10142@thunk.org>
	<CAGXu5jJx85b2ysgx2aXWUUf4dJMc34Cukp3S1VKiC_Pc5U2+Pw@mail.gmail.com>
	<20120327173744.GD10142@thunk.org>
	<CAGXu5j+itrR6cCWpXZAA0ZEP2KhdHdhcYA-R6pc=B97a_rHbaQ@mail.gmail.com>
	<4F74A2C9.1000009@zytor.com>
Date: Thu, 29 Mar 2012 11:13:23 -0700
Message-ID: <CAGXu5jKaHygqzfbtahSBCM=EQmqkS8br5ndnLp0QCRFaka11SA@mail.gmail.com>
Subject: Re: Correct way to include siginfo.h?
From: Kees Cook <keescook@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 10:58 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/27/2012 11:01 AM, Kees Cook wrote:
>>
>> No, siginfo, IIUC, is defined to be SI_MAX_SIZE bytes. The union for
>> seccomp (on SIGSYS) just uses a long and 2 ints. It'd be nice for
>> there to be a stable way to get the kernel's siginfo instead of
>> glibc's.
>>
>
> Make it safe for the kernel to export and make glibc use the kernel's
> version, just like everything else...

We'll have to poke the glibc folks. In the meantime, Will Drewry found
a stable way to handle this. Just make the first set of includes and
defines be:

#include <asm/siginfo.h>
#define __have_siginfo_t 1
#define __have_sigval_t 1
#define __have_sigevent_t 1

Then the glibc includes won't attempt the redefinition.

-Kees

-- 
Kees Cook
Chrome OS Security
