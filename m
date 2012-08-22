Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2HVBH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 21:07:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13326 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2HVBHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 21:07:23 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=msuDdjDmgMgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=7QJVW1qYD7oA:10 a=meVymXHHAAAA:8 a=KKAkSRfTAAAA:8 a=8KIC397upBrKEroIwb4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=WwgC8nHKvroA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345597639.5069.21.camel@gandalf.local.home>
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
Date: Tue, 21 Aug 2012 21:07:19 -0400
In-Reply-To: <20120821014605.GA32342@lizard>
References: <20120710001004.GA22744@lizard>
	 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
	 <1342553898.10332.9.camel@gandalf.stny.rr.com>
	 <20120717200130.GA31678@lizard>
	 <1342561102.10332.18.camel@gandalf.stny.rr.com>
	 <20120718034722.GA18081@lizard> <5006EE8C.20304@codeaurora.org>
	 <20120718185029.GA4184@lizard> <50070789.7040601@codeaurora.org>
	 <20120718193052.GA10220@lizard> <20120821014605.GA32342@lizard>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 18:46 -0700, Anton Vorontsov wrote:
> On Wed, Jul 18, 2012 at 12:30:52PM -0700, Anton Vorontsov wrote:
> > With this patch we no longer reuse function tracer infrastructure, now
> > we register our own tracer back-end via a debugfs knob.
> > 
> > It's a bit more code, but that is the only downside. On the bright side we
> > have:
> > 
> > - Ability to make persistent_ram module removable (when needed, we can
> >   move ftrace_ops struct into a module). Note that persistent_ram is still
> >   not removable for other reasons, but with this patch it's just one
> >   thing less to worry about;
> > 
> > - Pstore part is more isolated from the generic function tracer. We tried
> >   it already by registering our own tracer in available_tracers, but that
> >   way we're loosing ability to see the traces while we record them to
> >   pstore. This solution is somewhere in the middle: we only register
> >   "internal ftracer" back-end, but not the "front-end";
> > 
> > - When there is only pstore tracing enabled, the kernel will only write
> >   to the pstore buffer, omitting function tracer buffer (which, of course,
> >   still can be enabled via 'echo function > current_tracer').
> > 
> > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> > ---
> 
> Hi Steven,
> 
> Unless there are any issues, may I take the patch via linux-pstore.git
> tree?

I'm fine with it. I know there was some issues about recursion
protection and I said that the function tracer now has its own
protection where you don't need to worry about it. I was hoping that
code would make it into 3.6, but Linus opened the merge window the day
after I posted the final version. Which I figured was too close to the
merge window to push for 3.6 (lots of changes occurred, and I wanted it
vetted in linux-next for a bit).

Now those changes are queued for 3.7 and are currently in the tip tree.
You can supply your own temporary recursion protection to the function
tracer callback, or wait till my changes make it into Linus's tree.

Specifically, see commit 4740974a6844156c14d741b0080b59d275679a23 (in
tip.git).

-- Steve


