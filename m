Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3AFUYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 15:24:07 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:43054 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3AFUYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 15:24:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAKgNAkggu9+AuMRqTFeNy9sJVCMcZVRZx43t=svF=gm+P4DnuQ@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
	<CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
	<50749DE8.7010703@zytor.com>
	<CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
	<5074A0AB.8040207@zytor.com>
	<87d30o7iy6.fsf@rustcorp.com.au>
	<CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com>
	<87ipa8o4mn.fsf@rustcorp.com.au>
	<CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com>
	<87sj97hs5e.fsf@rustcorp.com.au>
	<CAHO5Pa29_=3HNLG-qtULZ2fmkgPJ6JCZ0LTv9m=UowfvFufhMw@mail.gmail.com>
	<87fw2j5dlj.fsf@rustcorp.com.au>
	<CAKgNAkggu9+AuMRqTFeNy9sJVCMcZVRZx43t=svF=gm+P4DnuQ@mail.gmail.com>
Date: Sun, 6 Jan 2013 13:24:03 -0700
X-Google-Sender-Auth: awqZSz8o0D-EP5nIek0a4Bb5cns
Message-ID: <CAGXu5jJXoYO3CzpENAZYANLzySPPjzDVO_qLonqwxUUu1Ux=sg@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
From: Kees Cook <keescook@chromium.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        jonathon@jonmasters.org, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 6, 2013 at 11:59 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hi Rusty, (and Lucas, and Kees)
>
> On Thu, Jan 3, 2013 at 1:12 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Michael Kerrisk <mtk.manpages@gmail.com> writes:
>>> Hi Rusty,
>>
>> Hi Michael,
>>
>>> The description here is rather thin. Could you supply a sentence or
>>> two for each of MODULE_INIT_IGNORE_MODVERSIONS and
>>> MODULE_INIT_IGNORE_VERMAGIC that would be suitable for the manual
>>> page?
>>>
>>> Thanks,
>>
>> There are one or two safety checks built into a module, which are
>> checked to match the kernel on module load.  The first is a "vermagic"
>> string containing the kernel version number and prominent features (such
>> as CPU type).  If the module was built with CONFIG_MODVERSIONS set, a
>> version hash is recorded for each symbol the module uses based on the
>> types it refers to: in this case, the kernel version number within the
>> "vermagic" string is ignored, as the symbol version hashes are assumed
>> to be sufficiently reliable.
>>
>> Using the MODULE_INIT_IGNORE_VERMAGIC flag indicates that the vermagic
>> is to be ignored, and the MODULE_INIT_IGNORE_MODVERSIONS flag indicates
>> that the version hashes are to be ignored.  If the kernel is built to
>> permit such forced loading (ie. CONFIG_MODULE_FORCE_LOAD is set) then
>> loading will continue, otherwise it will fail with ENOEXEC as expected
>> for malformed modules.
>>
>> Hope that is more usable?
>
> Yes, that helps. I did some reworking of that text. Hopefully, I did
> not introduce any errors.
>
> Below is the text that is proposed to document finit_module() in the
> man pages. I'd appreciate any review (Kees, Lucas, Rusty?)

Looks good to me!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

--
Kees Cook
Chrome OS Security
