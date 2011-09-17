Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1IQAAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:00:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37766 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab1IQAAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:00:33 -0400
Message-ID: <4E73E3C9.4040702@gmail.com>
Date: Sat, 17 Sep 2011 10:03:21 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: halfdog <me@halfdog.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mark Salter <msalter@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Pass correct length to strnlen_user in fs/exec.c
References: <4E680EBC.4000804@gmail.com> <20110908165213.6ebd844f.akpm@linux-foundation.org> <4E695784.7020303@gmail.com> <4E737B16.2090104@halfdog.net>
In-Reply-To: <4E737B16.2090104@halfdog.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/11 02:36, halfdog wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Ryan Mallon wrote:
>
>>> ...
>> That's fine. I originally went looking after a discussion with
>> Mark about the weird strnlen_user semantics  and this usage looked
>> incorrect to me because it wasn't obviously checking >=
>> MAX_ARG_STRLEN.
>>
>> The rework I think makes it a bit more clear and passes the correct
>> max length to strnlen_user. Its a bit odd to pass MAX_ARG_STRLEN
>> and then check if it is longer than bprm->len, and I guess assumes
>> that bprm->len is less than MAX_ARG_STRLEN.
>>
>> Feel free to drop the patch if you think it is just churn.
> As you are already busy with fs/exec.c and strnlen_user, could you
> please check, if the timerace (argv/envp corruption) using
> strnlen_user could also be fixed within the same patch (if bug still
> in kernel). See
>
> https://bugzilla.kernel.org/show_bug.cgi?id=39222

With kernel.org currently being down I cannot see that bug report
unfortunately, so I don't know what the bug you are referring to is.

> The race occurs when one thread issues exec while another one with
> shared memory pages is flipping char/0-bytes of the args or envptrs,
> causing random split (number greater maxargs - no problem, silently
> droped)/fusion (greater MAX_ARG_STRLEN - might harm dumb programs) or
> removal of all args including program name on top of new stack when
> calling via binfmt handlers (might have influenced old ldlinux/libc
> pre 2009?? when handling suid binaries)

It doesn't sound like my patch would have fixed that. The only issue
that my patch would have corrected is the case where bprm->len is
greater than MAX_ARG_STRLEN. MAX_ARG_STRLEN is pretty big though (32 *
PAGE_SIZE), so I don't see that being an issue very often.

~Ryan

