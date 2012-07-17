Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2GQSL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:11:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64998 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab2GQSL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:11:27 -0400
Date: Tue, 17 Jul 2012 11:09:18 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Message-ID: <20120717180918.GA18671@lizard>
References: <20120710001004.GA22744@lizard>
 <1341879046-5197-7-git-send-email-anton.vorontsov@linaro.org>
 <20120717165601.GA16001@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120717165601.GA16001@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 09:56:01AM -0700, Greg Kroah-Hartman wrote:
[...]
> That's nice, but it breaks the build on my system as linux_banner
> somehow isn't enabled as part of the build?

I really don't see how you managed to disable it. :-)

init/version.c is built unconditionally, and it has
'const char linux_banner[]' unconditionally. Then ram.c includes
kernel.h, which unconditionally (well, under #ifdef __KERNEL__)
includes printk.h, which has 'extern const char linux_banner[];'
prototype...

I'm still looking further, but can you please send your config
file? And may be gcc version?


p.s. While investigating this, I found that quite a lot of includes
are missing in pstore headers, and I was able to trigger at least
one issue. The patch will follow.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
