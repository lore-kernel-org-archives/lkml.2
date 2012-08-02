Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab2HBQzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:55:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63825 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab2HBQzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:55:04 -0400
MIME-Version: 1.0
In-Reply-To: <CABqD9hanETRn77YoXb0LzgcxVJKnV6Pkfkow_b2=456rad=fNg@mail.gmail.com>
References: <cover.1342566495.git.luto@amacapital.net> <912c85ae09ccb083110ae451d4f59260ae65296f.1342566495.git.luto@amacapital.net>
 <CALCETrUJiXoc8Jq-fdTsx4oq9j8e-NHSiYOJdy37o6uy2cJZuA@mail.gmail.com> <CABqD9hanETRn77YoXb0LzgcxVJKnV6Pkfkow_b2=456rad=fNg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 2 Aug 2012 09:54:43 -0700
Message-ID: <CALCETrVZ2V_W-oiwPoDUrqPSv79_gMjPdH_qe+FGWyXcD64rmg@mail.gmail.com>
Subject: Re: [PATCH 3.5 2/2] seccomp: Future-proof against silly tracers
To: Will Drewry <wad@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 7:32 AM, Will Drewry <wad@chromium.org> wrote:
> On Thu, Jul 26, 2012 at 10:41 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, Jul 17, 2012 at 4:19 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> Currently, if a tracer changes a syscall nr to __NR_future_enosys,
>>> behavior will differ between kernels that know about
>>> __NR_future_enosys (and return -ENOSYS) and older kernels (which
>>> return the value from pt_regs).  This is silly; we should just
>>> return -ENOSYS.
>>>
>>> This is unlikely to ever happen on x86 because the return value in
>>> pt_regs starts out as -ENOSYS, but a silly tracer can change that.
>>>
>>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>>> Cc: Will Drewry <wad@chromium.org>
>>> ---
>>>  arch/x86/include/asm/syscall.h |   11 +++++++++++
>>>  kernel/seccomp.c               |   15 +++++++++++++++
>>>  2 files changed, 26 insertions(+), 0 deletions(-)
>>
>> Will, can you pick this, or some version of it, up in your
>> seccomp-for-ARM tree or wherever your development is?
>
> I'm still not sure about this change though the end result is nice.
> Regardless, I'll explore it when I can -- my family has just increased
> in size, so I'm going to be a bit delayed!

I don't think there's any particular rush here.  It's a very minor ABI
change, but I had to write code to explicitly look for it to detect
any difference at all.

--Andy


>
> cheers!
> will



-- 
Andy Lutomirski
AMA Capital Management, LLC
