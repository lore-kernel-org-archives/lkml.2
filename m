Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab2JRNAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:00:09 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64166 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab2JRNAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:00:07 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87ipa8o4mn.fsf@rustcorp.com.au>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
 <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
 <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
 <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au>
 <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com> <87ipa8o4mn.fsf@rustcorp.com.au>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 18 Oct 2012 14:59:46 +0200
Message-ID: <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        jonathon@jonmasters.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 5:12 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> Sure. But my point that started this subthread was: should we take the
>> opportunity now to add a 'flags' argument to the new finit_module()
>> system call, so as to allow flexibility in extending the behavior in
>> future? There have been so many cases of revised system calls in the
>> past few years that replaced calls without a 'flags' argument that it
>> seems worth at least some thought before the API is cast in stone.
>
> (CC's trimmed, Lucas & Jon added; please include them in module
> discussions!)
>
> So I tried to think of why we'd want flags; if I could think of a
> plausible reason, obviously we should do it now.
>
> I think it would be neat for the force flags (eg. ignoring modversions
> or ignoring kernel version).  These are the only cases where libkmod
> needs to mangle the module.
>
> So here's the patch which adds the flags field, but nothing in there
> yet.  I'll add the remove flags soon, so libkmod can assume that if the
> syscall exists, those flags will work.
>
> Thoughts?
> Rusty.
>
> FIX: add flags arg to sys_finit_module()
>
> Thanks to Michael Kerrisk for keeping us honest.

w00t! Thanks, Rusty ;-).

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

> +       if (flags)
> +               return -EINVAL;

And thanks for that check. So easy, so obvious, and so often forgotten.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
