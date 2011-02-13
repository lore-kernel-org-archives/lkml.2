Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1BMV2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 16:28:30 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65201 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab1BMV20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 16:28:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rqvJ81NgjUHLSk3yV4W2QsLH1KFpqZvKBCUKwGQVKOdxZZbfy76S2ouBXicuUwNjIg
         XtYleDTnGRp0lq9hM2L4xgBxgmi2hww66CvWe3xYbGylcMEd0baDUkDPe/uLvzuGISlb
         q/Gnq656mohLqGeCfZpfbzJglmpHAr6IIUgek=
MIME-Version: 1.0
In-Reply-To: <4D584A49.80306@zytor.com>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<201102132110.29630.arnd@arndb.de>
	<AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>
	<4D584A49.80306@zytor.com>
Date: Sun, 13 Feb 2011 13:28:25 -0800
Message-ID: <AANLkTikbFM5BjcD1=KsO-tHpHn-01Sxnqp40_GtbifYY@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x32-abi@googlegroups.com, Arnd Bergmann <arnd@arndb.de>,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 1:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/13/2011 01:10 PM, H.J. Lu wrote:
>>> The basic concept looks entirely reasonable to me, but I'm
>>> curious what drove the decision to start out with the x86_64
>>> system calls instead of the generic ones.
>>>
>>> Since tile was merged, we now have support for compat syscalls
>>> in the generic syscall ABI. I would have assumed that it
>>> was possible to just use those if you decide to do a new
>>> ABI in the first place.
>>>
>>> The other option that would have appeared natural to me is
>>> to just use the existing 32 bit compat ABI with the few
>>> necessary changes done based on the personality.
>
> The actual idea is to use the i386 compat ABI for memory layout, but
> with a 64-bit register convention.  That means that system calls that
> don't make references to memory structures can simply use the 64-bit
> system calls, otherwise we're planning to reuse the i386 compat system
> calls, but invoke them via the syscall instruction (which requires a new
> system call table) and to pass 64-bit arguments in single registers.
>

That is is currently implemented on hjl/x32 branch.

I also added

__NR_sigaction
__NR_sigpending
__NR_sigprocmask
__NR_sigsuspend

to help the Bionic C library.


-- 
H.J.
