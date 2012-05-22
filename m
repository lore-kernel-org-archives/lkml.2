Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2EVEzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:55:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42467 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2EVEzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:55:41 -0400
Date: Mon, 21 May 2012 21:54:07 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Kees Cook <keescook@chromium.org>
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
Subject: Re: [PATCH 14/14] pstore/platform: Remove automatic updates
Message-ID: <20120522045406.GA24770@lizard>
References: <20120518222314.GA9425@lizard>
 <20120518222639.GN23089@lizard>
 <CAGXu5j+kE+cagPSjF5yGsxvuwxTaFY3t_BmiroJ+qCx2Fydstg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5j+kE+cagPSjF5yGsxvuwxTaFY3t_BmiroJ+qCx2Fydstg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 12:59:59PM -0700, Kees Cook wrote:
[...]
> Hrm. This complicates testing a bit. I need more convincing. :)
> 
> Systems run with panic_on_oops=0, and plenty of failure paths will
> just kill "current" instead of bringing the entire system down. I
> would much rather allow for the possibility to get oopses when they
> happen than to have to wait a full reboot cycle to "notice" them.

Well, as I use qemu/kvm for testing, rebooting is actually faster
than waiting for 60 seconds, so I didn't consider this use-case. :-)
But yes, I see the point: as pstore's debug function of itself,
updates might make sense.

So, you mentioning the panic_on_oops made me think of a kernel
command line option, this will also eliminate the 60 seconds hard-
coded interval.

But personally I'd still like it disabled by default, otherwise it
is possible pstore to screw things because of itself, and that
eliminates the point of having it as a reliable debug facility;
IMO, it should as much non-intrusive by default as possible, and
that's what we would want for production kernels anyway.

I'll replace this patch with another one that will add
pstore.update_ms kernel command line option.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
