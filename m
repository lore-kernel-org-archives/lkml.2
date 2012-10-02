Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2JBUeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:34:09 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50416 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab2JBUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
Date: Tue, 2 Oct 2012 13:34:06 -0700
X-Google-Sender-Auth: aWyU9wWkKSi9_4BtMM_ThsQerOA
Message-ID: <CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
Subject: Re: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Kees Cook <keescook@chromium.org>
To: Ard Biesheuvel <ard.biesheuvel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 20, 2012 at 2:48 PM, Ard Biesheuvel
<ard.biesheuvel@gmail.com> wrote:
>> This seems like a good idea to me. It would allow more than just the
>> loader to harden userspace allocations. It's a more direct version of
>> PaX's "MPROTECT" feature[1]. That feature hardens existing loaders,
>> but doesn't play nice with JITs (like Java), but this lets a loader
>> (or JIT) opt-in to the protection and have some direct control over it.
>
> If desired, additional restrictions can be imposed by using the
> security framework, e.g,, disallow non-final r-x mappings.

Interesting; what kind of interface did you have in mind?

>> It seems like there needs to be a sensible way to detect that this flag is
>> available, though.
>
> I am open for suggestions to address this. Our particular
> implementation of the loader (on an embedded system) tries to set it
> on the first mmap invocation, and stops trying if it fails. Not the
> most elegant approach, I know ...

Actually, that seems easiest.

Has there been any more progress on this patch over-all?

-Kees

-- 
Kees Cook
Chrome OS Security
