Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab2EUUAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:00:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42363 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833Ab2EUUAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:00:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120518222639.GN23089@lizard>
References: <20120518222314.GA9425@lizard>
	<20120518222639.GN23089@lizard>
Date: Mon, 21 May 2012 12:59:59 -0700
X-Google-Sender-Auth: J7-ezfM7m-Vk_6zBfzg4vkfeGYg
Message-ID: <CAGXu5j+kE+cagPSjF5yGsxvuwxTaFY3t_BmiroJ+qCx2Fydstg@mail.gmail.com>
Subject: Re: [PATCH 14/14] pstore/platform: Remove automatic updates
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 3:26 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Having automatic updates seems pointless, and even dangerous
> and thus counter-productive:
>
> 1. If we can mount pstore, or read files, we can as well read
>   /proc/kmsg. So, there's little point in duplicating the
>   functionality and present the same information but via another
>   userland ABI;
>
> 2. Expecting the kernel to behave sanely after oops/panic is naive.
>   It might work, but you'd rather not try it. Screwed up kernel
>   can do rather bad things, like recursive faults[1]; and pstore
>   rather provoking bad things to happen. It uses:
>
>   1. Timers (assumes sane interrupts state);
>   2. Workqueues and mutexes (assumes scheduler in a sane state);
>   3. kzalloc (a working slab allocator);
>
>   That's too much for a dead kernel, so the debugging facility
>   itself might just make debugging harder, which is not what
>   we want.
>
> So, let's remove the automatic updates, this keeps things simple
> and safe.
>
> (Maybe for non-oops message types it would make sense to add
> automatic updates, but so far I don't see any use case for this.
> Even for tracing, it has its own run-time/normal ABI, so we're
> only interested in pstore upon next boot, to retrieve what has
> gone wrong with HW or SW.)

Hrm. This complicates testing a bit. I need more convincing. :)

Systems run with panic_on_oops=0, and plenty of failure paths will
just kill "current" instead of bringing the entire system down. I
would much rather allow for the possibility to get oopses when they
happen than to have to wait a full reboot cycle to "notice" them.

-Kees

-- 
Kees Cook
Chrome OS Security
