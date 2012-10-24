Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161379Ab2JXVxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:53:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59879 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161224Ab2JXVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <20121024144442.6253965d.akpm@linux-foundation.org>
References: <20121024205756.GA12419@www.outflux.net>
	<20121024140227.299041a9.akpm@linux-foundation.org>
	<CAGXu5jK2kNgccbbuadjUFn+bbj9_02HbQfjUDeL4sNz1GWtHEQ@mail.gmail.com>
	<20121024144442.6253965d.akpm@linux-foundation.org>
Date: Wed, 24 Oct 2012 14:53:33 -0700
X-Google-Sender-Auth: 8xduLRYO1Q3KATVQenl_XxMc_Cg
Message-ID: <CAGXu5jJBLcdfhv8=LNkXZ6h4xsXrDZP094fojnPpJ0OcwnCtSA@mail.gmail.com>
Subject: Re: [RESEND][PATCH] gen_init_cpio: avoid stack overflow when expanding
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 2:44 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 24 Oct 2012 14:33:02 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> On Wed, Oct 24, 2012 at 2:02 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Wed, 24 Oct 2012 13:57:56 -0700
>> > Kees Cook <keescook@chromium.org> wrote:
>> >
>> >> Fix possible overflow of the buffer used for expanding environment
>> >> variables when building file list.
>> >>
>> >> $ cat usr/crash.list
>> >> file foo ${BIG}${BIG}${BIG}${BIG}${BIG}${BIG} 0755 0 0
>> >> $ BIG=$(perl -e 'print "A" x 4096;') ./usr/gen_init_cpio usr/crash.list
>> >> *** buffer overflow detected ***: ./usr/gen_init_cpio terminated
>> >>
>> >> This also replaces the space-indenting with tabs.
>> >>
>> >> Patch based on existing fix extracted from grsecurity.
>> >>
>> >> ...
>> >>
>> >> Cc: stable@vger.kernel.org
>> >
>> > Why did you feel we need to backport this to -stable?
>>
>> It's an extremely hard to hit security issue, but it's a security fix
>> regardless. I won't cry if it doesn't go to stable, but it seems a
>> trivial fix, so I included it for stable.
>
> Well, I do think that a description of the user impact of the bug
> should be included in the changelog so that poor old Greg can work out
> why we sent it at him.
>
> If you can suggest some suitable text I can copy-n-slurp that into the
> changelog.

How about replacing the first paragraph with:

Fix possible overflow of the buffer used for expanding environment
variables when building file list. In the extremely unlikely case of
an attacker having control over the environment variables visible to
gen_init_cpio, control over the contents of the file gen_init_cpio
parses, and gen_init_cpio was built without compiler hardening, the
attacker can gain arbitrary execution control via a stack buffer
overflow.


-Kees

-- 
Kees Cook
Chrome OS Security
