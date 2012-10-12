Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2JLHnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:43:02 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39189 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab2JLHnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:43:00 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87wqyx7me7.fsf@rustcorp.com.au>
References: <20120920232737.GA2953@www.outflux.net> <CAKgNAkheF8=ssrE=_JP-ApDP5zXeHSYVG+0x6Wfd6U28TcPSHQ@mail.gmail.com>
 <87wqyx7me7.fsf@rustcorp.com.au>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 12 Oct 2012 09:42:38 +0200
Message-ID: <CAKgNAkiKajiFxjfBEadXBtD67ApyGEvCa+uoWm7iFBBm0gnshA@mail.gmail.com>
Subject: Re: [PATCH] init_module: update to modern interfaces
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-man <linux-man@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Thanks for the review! One open question below.

On Thu, Oct 11, 2012 at 4:50 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> [CC widened, so that some more review might come in. Rusty?]
>
> Sure.
>
> Looks good. but:
>
>> .B EBUSY
>> The module's initialization routine failed.
>
> Possibly.  You should mention that the individual module's
> initialization routine can return other errors as appropriate.

Done!

In fact, the existing EBUSY text seems completely bogus. Should it not
read something like
"Timeout while trying to resolve a symbol reference by this module."?

>> .BR EINVAL " (Linux 2.4 and earlier)"
>> Some
>> .I image
>> slot is filled in incorrectly,
>> .I image\->name
>> does not correspond to the original module name, some
>> .I image\->deps
>> entry does not correspond to a loaded module,
>> or some other similar inconsistency.
>> .TP
>
> Why document this?

Because the general approach in man-pages is to document past as well
as current behavior. Since there are few user-space customers of
init_module(), perhaps you are right that this is unnecessary. I
dropped it.

>> .B ENOEXEC
>> The ELF image in
>> .I module_image
>> is too small or has corrupted segments.
>
> Or is not an ELF image, or wrong arch...

Yes, reworded here.

[...]

> You might want to note that the 2.4 syscall can be detected by calling
> query_module(): 2.6 and above give ENOSYS.

Done.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
