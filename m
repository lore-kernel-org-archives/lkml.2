Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565Ab2JDI0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:26:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45443 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab2JDI0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLY8kFaTMNetqnO_PHwkCCfqkaTxTZQdSc1AwcDiAr86g@mail.gmail.com>
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
	<CAGXu5jLY8kFaTMNetqnO_PHwkCCfqkaTxTZQdSc1AwcDiAr86g@mail.gmail.com>
Date: Thu, 4 Oct 2012 10:26:37 +0200
Message-ID: <CAKFga-d+Fyryh6_D6Nf6vGKWs9K_GP0t86dJSBRStpfHnmnviw@mail.gmail.com>
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Ard Biesheuvel <ard.biesheuvel@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, pageexec@freemail.hu,
        Roland McGrath <roland@hack.frob.com>, Nick Kralevich <nnk@google.com>,
        enh <enh@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/4 Kees Cook <keescook@chromium.org>:
> On Wed, Oct 3, 2012 at 2:18 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> Again: has this proposal been reviewed by the glibc maintainers?  If
>> so, what was their position on it?
>
> Ard have you talked with them? I would expect it would be welcomed.
> Roland, do you know who would be the right person to ask about this
> for glibc? (patch: https://lkml.org/lkml/2012/10/3/262)
>

I haven't spoken to the glibc people. However, I have been in contact
with the Android/Bionic people (on CC) to merge back some of the
security/hardening enhancements I have been making to Android on
behalf of my employer. This change is part of that.

I will post to the libc mailing list and once I get some feedback I
will post the summary here.

>> Also, you earlier stated that "It's a more direct version of PaX's
>> "MPROTECT" feature[1]".  This is useful information.  Please update the
>> changelog to describe that PaX feature and to describe the difference
>> between the two, and the reasons for that difference.
>
> AIUI, it's much more aggressive. It tries to protect all processes
> automatically (rather than this which is at the request of the
> process) and gets in the way of things like Java that expect to be
> able to do w+x mappings.
>

The main difference is that PROT_FINAL is just a feature. It is
completely up to the userland to decide in which cases (if at all) to
use it, which -as Kees points out- makes it a lot easier to allow
certain cases (ashmem filebacked rwx mappings for the JIT heap) while
ruling out all others. By implementing it in the loader, the vast
majority of code, rodata and relro mappings are hardened while
explicit uses of mmap/mprotect in userland code are completely
unaffected.

OTOH PaX's MPROTECT is a full blown policy implemented inside the
kernel. It imposes rules on which of the various combinations of VM_*
and VM_MAY* are permissible with little or no control from userland.

-- 
Ard.
