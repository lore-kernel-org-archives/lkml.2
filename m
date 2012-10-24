Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab2JXVdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:33:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50767 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783Ab2JXVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:33:04 -0400
MIME-Version: 1.0
In-Reply-To: <20121024140227.299041a9.akpm@linux-foundation.org>
References: <20121024205756.GA12419@www.outflux.net>
	<20121024140227.299041a9.akpm@linux-foundation.org>
Date: Wed, 24 Oct 2012 14:33:02 -0700
X-Google-Sender-Auth: exexBaAxnjRR_g8touU_3lvBJ6w
Message-ID: <CAGXu5jK2kNgccbbuadjUFn+bbj9_02HbQfjUDeL4sNz1GWtHEQ@mail.gmail.com>
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

On Wed, Oct 24, 2012 at 2:02 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 24 Oct 2012 13:57:56 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> Fix possible overflow of the buffer used for expanding environment
>> variables when building file list.
>>
>> $ cat usr/crash.list
>> file foo ${BIG}${BIG}${BIG}${BIG}${BIG}${BIG} 0755 0 0
>> $ BIG=$(perl -e 'print "A" x 4096;') ./usr/gen_init_cpio usr/crash.list
>> *** buffer overflow detected ***: ./usr/gen_init_cpio terminated
>>
>> This also replaces the space-indenting with tabs.
>>
>> Patch based on existing fix extracted from grsecurity.
>>
>> ...
>>
>> Cc: stable@vger.kernel.org
>
> Why did you feel we need to backport this to -stable?

It's an extremely hard to hit security issue, but it's a security fix
regardless. I won't cry if it doesn't go to stable, but it seems a
trivial fix, so I included it for stable.

-Kees

-- 
Kees Cook
Chrome OS Security
