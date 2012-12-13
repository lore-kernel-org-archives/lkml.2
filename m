Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2LMTci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:32:38 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45800 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab2LMTch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:32:37 -0500
MIME-Version: 1.0
In-Reply-To: <1355383038.18653.2.camel@wall-e>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>
 <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>
 <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e>
 <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Dec 2012 11:32:16 -0800
Message-ID: <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 11:17 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Mittwoch, den 12.12.2012, 22:47 -0800 schrieb H. Peter Anvin:
>> Should be a simple matter of sharing pages.  Look perhaps at the x32 vdso for a hint.
>>
>
>
>> >
>> >Any idea or clean solution how i can map the 64 bit vgtod into the 32
>> >bit address space? Thats the only problem i see.
>> >
>
> No, i see no special handling for x32 vdso to do this. I am not sure if
> x32 vdso can access the 64 bit address space of vsyscall_gtod_data. I
> can't test this due the lack of a x32 abi system.
>
>

x32's vdso cheats -- x32 code can see high addresses just fine.  The
toolchain just makes it difficult.

Your best bet is probably to just map the vvar page twice -- once at
the same address as native 32-bit mode (but only for compat tasks)
would use and once in the usual fixmap location.  You can't use the
fixmap for the compat mapping, though, since it would be a *user*
address.

For HPET support, you'd have to have special support.  I'd say to skip
it for compat mode.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
