Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab2EPWNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:13:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51026 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759594Ab2EPWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:13:15 -0400
Date: Wed, 16 May 2012 15:11:43 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
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
Subject: Re: [PATCH 4/6] pstore/ram: Add some more documentation and examples
Message-ID: <20120516221143.GA20576@lizard>
References: <20120516125330.GA15460@lizard>
 <20120516125658.GD20475@lizard>
 <CAMbhsRRmcaS7W-eY2eiiBa6xeAeeG+t5Bj4yVmKqkiFbs1bV3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMbhsRRmcaS7W-eY2eiiBa6xeAeeG+t5Bj4yVmKqkiFbs1bV3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:56:09AM -0700, Colin Cross wrote:
[...]
> > +You can specify either RAM memory or peripheral devices' memory. However, when
> > +specifying RAM, be sure to reserve the memory by issuing memblock_reserve()
> > +very early in the architecture code, just before platform device registration,
> 
> Just before platform device registration is way too late.  ARM
> provides a machine reserve callback to allow board files to call
> memblock_reserve inside arm_memblock_init() and before mm_init().

Yeah, and I guess that 'too late' is also true for all architectures,
the platform_device_register and friends are most probably unusable
before mm_init, and after that it's always too late.

So the word 'just' is misleading indeed, I'll remove it.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
