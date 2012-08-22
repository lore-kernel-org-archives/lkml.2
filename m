Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2HVCMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:12:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41248 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2HVCMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:12:51 -0400
Date: Tue, 21 Aug 2012 19:10:17 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3] pstore/ftrace: Convert to its own enable/disable
 debugfs knob
Message-ID: <20120822021017.GA13779@lizard>
References: <1342553898.10332.9.camel@gandalf.stny.rr.com>
 <20120717200130.GA31678@lizard>
 <1342561102.10332.18.camel@gandalf.stny.rr.com>
 <20120718034722.GA18081@lizard>
 <5006EE8C.20304@codeaurora.org>
 <20120718185029.GA4184@lizard>
 <50070789.7040601@codeaurora.org>
 <20120718193052.GA10220@lizard>
 <20120821014605.GA32342@lizard>
 <1345597639.5069.21.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345597639.5069.21.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 09:07:19PM -0400, Steven Rostedt wrote: [...]
> I'm fine with it. I know there was some issues about recursion
> protection and I said that the function tracer now has its own
> protection where you don't need to worry about it. I was hoping that
> code would make it into 3.6, but Linus opened the merge window the day
> after I posted the final version. Which I figured was too close to the
> merge window to push for 3.6 (lots of changes occurred, and I wanted
> it vetted in linux-next for a bit).
> 
> Now those changes are queued for 3.7 and are currently in the tip
> tree.  You can supply your own temporary recursion protection to the
> function tracer callback, or wait till my changes make it into Linus's
> tree.

Great! Btw, the particular recursion issue that I faced back then was
triggered by a missing 'notrace' specifier for the ->write() callback in
pstore code, i.e. a bug in pstore.

Running without any recursion protection is prone to weird
lockups/reboots, and probably a good idea to have it on a production
system. But recursion during tracing is still an evidence of some other
bugs, right? At least the fact that I didn't have it helped me to find a
bug. So, does it make sense to make the recursion protection optionally
disabled? Maybe as some CONFIG_DEBUG_* option (briefly looking into
kernel/trace/Kconfig I didn't find any)?

Thanks,

Anton.
