Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab2IUVKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:10:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36712 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2IUVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:10:10 -0400
MIME-Version: 1.0
In-Reply-To: <505CD629.1070402@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
 <CA+55aFwaZdMxLA1VCfOy9BDQHPp6CTwRFHYGUCXdJ4+KkQoN+g@mail.gmail.com>
 <20120921200846.GA25679@gmail.com> <505CD629.1070402@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Sep 2012 14:09:48 -0700
X-Google-Sender-Auth: ulzzaR1iRd2-ebaI3i-DnhB3vaU
Message-ID: <CA+55aFzsFSyKWQUFOH=ApeUhvNTyhcEkZ8ddYbdoBx8yuxVQeA@mail.gmail.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 2:03 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> A while ago I also did a mockup patch which switched %cr3 to
> swapper_pg_dir while entering the kernel (basically where the CLAC
> instructions go, plus the SYSCALL path; a restore was obviously needed,
> too.)  The performance was atrocious, but I didn't remember running into
> any problems.

Well, they are bound to be corner-cases and unusual. I was thinking of
problems like the one recently fixed in commit ed6fe9d614fc ("Fix
order of arguments to compat_put_time[spec|val]"), which really
requires compat handling of fairly unusual cases.

That's the kind of situation where I'd expect bugs might still lurk.
And it would only get triggered by some rather unusual setups.

             Linus
