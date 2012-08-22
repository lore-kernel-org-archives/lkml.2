Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab2HVCZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:25:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2HVCZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:25:04 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=msuDdjDmgMgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=7QJVW1qYD7oA:10 a=meVymXHHAAAA:8 a=diSC_ZETfQ4tWXyqroUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345602300.5069.25.camel@gandalf.local.home>
Subject: Re: [PATCH v3] pstore/ftrace: Convert to its own enable/disable
 debugfs knob
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
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
Date: Tue, 21 Aug 2012 22:25:00 -0400
In-Reply-To: <20120822021017.GA13779@lizard>
References: <1342553898.10332.9.camel@gandalf.stny.rr.com>
	 <20120717200130.GA31678@lizard>
	 <1342561102.10332.18.camel@gandalf.stny.rr.com>
	 <20120718034722.GA18081@lizard> <5006EE8C.20304@codeaurora.org>
	 <20120718185029.GA4184@lizard> <50070789.7040601@codeaurora.org>
	 <20120718193052.GA10220@lizard> <20120821014605.GA32342@lizard>
	 <1345597639.5069.21.camel@gandalf.local.home>
	 <20120822021017.GA13779@lizard>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 19:10 -0700, Anton Vorontsov wrote:

> Running without any recursion protection is prone to weird
> lockups/reboots, and probably a good idea to have it on a production
> system. But recursion during tracing is still an evidence of some other
> bugs, right? At least the fact that I didn't have it helped me to find a
> bug. So, does it make sense to make the recursion protection optionally
> disabled? Maybe as some CONFIG_DEBUG_* option (briefly looking into
> kernel/trace/Kconfig I didn't find any)?

The problem is that recursion bugs are usually due to calling something
that might be traced. Really, I've hit so many recursion bugs, that
having the protection is probably the best thing. I wouldn't turn it
off.

The worse that recursion can do (with proper protection) is that it
causes a little wasted effort during the trace (it wastes cycles tracing
something again and then recognizing that it is doing it due to
recursion).

Therefore, the 'notrace' annotations are mostly for speed up (don't
trace this while tracing, because the tracer uses it too).

-- Steve


