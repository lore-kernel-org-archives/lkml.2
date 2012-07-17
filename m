Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2GQQ4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:56:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59319 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2GQQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:56:08 -0400
Date: Tue, 17 Jul 2012 09:56:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 7/8] pstore/ram: Make tracing log versioned
Message-ID: <20120717165601.GA16001@kroah.com>
References: <20120710001004.GA22744@lizard>
 <1341879046-5197-7-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341879046-5197-7-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 05:10:45PM -0700, Anton Vorontsov wrote:
> Decoding the binary trace w/ a different kernel might be troublesome
> since we convert addresses to symbols. For kernels with minimal changes,
> the mappings would probably match, but it's not guaranteed at all.
> (But still we could convert the addresses by hand, since we do print
> raw addresses.)
> 
> If we use modules, the symbols could be loaded at different addresses
> from the previously booted kernel, and so this would also fail, but
> there's nothing we can do about it.
> 
> Also, the binary data format that pstore/ram is using in its ringbuffer
> may change between the kernels, so here we too must ensure that we're
> running the same kernel.
> 
> So, there are two questions really:
> 
> 1. How to compute the unique kernel tag;
> 2. Where to store it.
> 
> In this patch we're just passing linux_banner through CRC32.

That's nice, but it breaks the build on my system as linux_banner
somehow isn't enabled as part of the build?

Is there something else you can use?  Or fix the build to work properly?

I'll take the previous patches in the series, but I obviously can't take
this one because of the build error, sorry.

greg k-h
