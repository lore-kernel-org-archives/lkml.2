Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2LNAKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:10:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41057 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab2LNAKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:10:32 -0500
Message-ID: <50CA6E4C.6000305@zytor.com>
Date: Thu, 13 Dec 2012 16:09:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
References: <1355343572-23074-1-git-send-email-stefani@seibold.net> <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e> <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e> <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e> <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com>
In-Reply-To: <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 11:32 AM, Andy Lutomirski wrote:
>
> x32's vdso cheats -- x32 code can see high addresses just fine.  The
> toolchain just makes it difficult.
>
> Your best bet is probably to just map the vvar page twice -- once at
> the same address as native 32-bit mode (but only for compat tasks)
> would use and once in the usual fixmap location.  You can't use the
> fixmap for the compat mapping, though, since it would be a *user*
> address.
>
> For HPET support, you'd have to have special support.  I'd say to skip
> it for compat mode.
>

Whatever data you need you can just map it into the vdso range.  There 
really shouldn't be anything special about that at all.

The fixmap stuff is an x86-64 legacy that you don't have to worry about, 
obviously.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

