Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2GQWIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:08:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45209 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab2GQWIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:08:38 -0400
Date: Tue, 17 Jul 2012 15:06:26 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 3/8] pstore: Add persistent function tracing
Message-ID: <20120717220625.GA32645@lizard>
References: <20120710001004.GA22744@lizard>
 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
 <1342553898.10332.9.camel@gandalf.stny.rr.com>
 <20120717200130.GA31678@lizard>
 <1342561102.10332.18.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1342561102.10332.18.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 05:38:22PM -0400, Steven Rostedt wrote:
[...]
> > > BTW, can any of the called functions go into module code that can be
> > > removed? If so, then this is not safe at all. Normal function tracing
> > > can not be synced in a preemptible kernel.
> > 
> > Um. Yes, psinfo->write_buf() might be in the module. Nice catch.

Oh, actually, while write_buf() can technically be in a removable module,
the RAM backend can't be removed once loaded. So it is not a real issue.
But I'll implement your idea anyway, it seems a bit cleaner and safer,
plus if we ever want to make persistent_ram backend removable, we won't
need to bother w/ this particular issue.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
