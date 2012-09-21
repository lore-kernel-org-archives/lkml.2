Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab2IUVNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:13:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52846 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077Ab2IUVNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:13:08 -0400
Message-ID: <505CD854.1030502@zytor.com>
Date: Fri, 21 Sep 2012 14:12:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com> <CA+55aFwaZdMxLA1VCfOy9BDQHPp6CTwRFHYGUCXdJ4+KkQoN+g@mail.gmail.com> <20120921200846.GA25679@gmail.com> <505CD629.1070402@linux.intel.com> <CA+55aFzsFSyKWQUFOH=ApeUhvNTyhcEkZ8ddYbdoBx8yuxVQeA@mail.gmail.com>
In-Reply-To: <CA+55aFzsFSyKWQUFOH=ApeUhvNTyhcEkZ8ddYbdoBx8yuxVQeA@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 02:09 PM, Linus Torvalds wrote:
> On Fri, Sep 21, 2012 at 2:03 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>> A while ago I also did a mockup patch which switched %cr3 to
>> swapper_pg_dir while entering the kernel (basically where the CLAC
>> instructions go, plus the SYSCALL path; a restore was obviously needed,
>> too.)  The performance was atrocious, but I didn't remember running into
>> any problems.
> 
> Well, they are bound to be corner-cases and unusual. I was thinking of
> problems like the one recently fixed in commit ed6fe9d614fc ("Fix
> order of arguments to compat_put_time[spec|val]"), which really
> requires compat handling of fairly unusual cases.
> 
> That's the kind of situation where I'd expect bugs might still lurk.
> And it would only get triggered by some rather unusual setups.
> 

Yes; in *most* cases these are exploitable security bugs on non-SMAP
hardware (which is obviously the whole point!), but there are a few
conditions where there may be issues that aren't exploitable problems.

	-hpa



