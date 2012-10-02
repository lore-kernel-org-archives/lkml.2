Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2JBWK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:10:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52612 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2JBWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
	<CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
	<CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
Date: Tue, 2 Oct 2012 15:10:56 -0700
X-Google-Sender-Auth: 5c1JydoOvL6UolxYrCK94LJSPhs
Message-ID: <CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com>
Subject: Re: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Kees Cook <keescook@chromium.org>
To: Ard Biesheuvel <ard.biesheuvel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        James Morris <jmorris@namei.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 2:41 PM, Ard Biesheuvel <ard.biesheuvel@gmail.com> wrote:
> 2012/10/2 Kees Cook <keescook@chromium.org>:
>>> If desired, additional restrictions can be imposed by using the
>>> security framework, e.g,, disallow non-final r-x mappings.
>>
>> Interesting; what kind of interface did you have in mind?
>
> The 'interface' we use is a LSM .ko which registers handlers for
> mmap() and mprotect() that fail the respective invocations if the
> passed arguments do not adhere to the policy.

Seems reasonable.

>>>> It seems like there needs to be a sensible way to detect that this flag is
>>>> available, though.
>>>
>>> I am open for suggestions to address this. Our particular
>>> implementation of the loader (on an embedded system) tries to set it
>>> on the first mmap invocation, and stops trying if it fails. Not the
>>> most elegant approach, I know ...
>>
>> Actually, that seems easiest.
>>
>> Has there been any more progress on this patch over-all?
>
> No progress.

Al, Andrew, anyone? Thoughts on this?
(First email is https://lkml.org/lkml/2012/8/14/448)

-Kees

-- 
Kees Cook
Chrome OS Security
