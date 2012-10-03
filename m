Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2JCWT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:19:28 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34536 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab2JCWT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:19:27 -0400
MIME-Version: 1.0
In-Reply-To: <20121003141804.f9896690.akpm@linux-foundation.org>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
	<CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
	<CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
	<CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com>
	<20121002153841.a03ad73b.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1210021733580.1343@eggly.anvils>
	<506C4F29.4090303@gmail.com>
	<20121003141804.f9896690.akpm@linux-foundation.org>
Date: Wed, 3 Oct 2012 15:19:26 -0700
X-Google-Sender-Auth: uIaut_B1qTZhPsThDe4Kh_NfxiI
Message-ID: <CAGXu5jLY8kFaTMNetqnO_PHwkCCfqkaTxTZQdSc1AwcDiAr86g@mail.gmail.com>
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@gmail.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, pageexec@freemail.hu,
        Roland McGrath <roland@hack.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 2:18 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 03 Oct 2012 16:43:53 +0200
> Ard Biesheuvel <ard.biesheuvel@gmail.com> wrote:
>
>> This patch adds support for the PROT_FINAL flag to
>> the mmap() and mprotect() syscalls.
>>
>> The PROT_FINAL flag indicates that the requested set
>> of protection bits should be final, i.e., it shall
>> not be allowed for a subsequent mprotect call to
>> set protection bits that were not set already.
>>
>> This is mainly intended for the dynamic linker,
>> which sets up the address space on behalf of
>> dynamic binaries. By using this flag, it can
>> prevent exploited code from remapping read-only
>> executable code or data sections read-write.
>
> Again: has this proposal been reviewed by the glibc maintainers?  If
> so, what was their position on it?

Ard have you talked with them? I would expect it would be welcomed.
Roland, do you know who would be the right person to ask about this
for glibc? (patch: https://lkml.org/lkml/2012/10/3/262)

> Also, you earlier stated that "It's a more direct version of PaX's
> "MPROTECT" feature[1]".  This is useful information.  Please update the
> changelog to describe that PaX feature and to describe the difference
> between the two, and the reasons for that difference.

AIUI, it's much more aggressive. It tries to protect all processes
automatically (rather than this which is at the request of the
process) and gets in the way of things like Java that expect to be
able to do w+x mappings.

> It sounds as though the PaX developers could provide useful review
> input on this proposal.  Do they know about it?  If so, what is their
> position?

I'd rather not speak for them, but I understood it to be along the
lines of "that's nice, we'll keep ours." :) (Now added to CC.)

-Kees

-- 
Kees Cook
Chrome OS Security
