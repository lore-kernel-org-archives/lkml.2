Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab2HWJIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 05:08:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27501 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2HWJIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 05:08:09 -0400
X-Authority-Analysis: v=2.0 cv=A87uztqG c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YOaqkLwX9aQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=7mug7doFhEcA:10 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=xcmSSfFKk9aoRfOygJgA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=2E9KpQmbqmkee8fr:21 a=23-myU_EOx042zky:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345712886.5069.41.camel@gandalf.local.home>
Subject: Re: [PATCH 2/5] trace-cmd: Use tracing directory to count CPUs
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Amit Shah <amit.shah@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>, Arnd Bergmann <arnd@arndb.de>,
        Borislav Petkov <bp@amd64.org>, "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 23 Aug 2012 05:08:06 -0400
In-Reply-To: <50359CE9.3000509@hitachi.com>
References: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>
	  <20120822084312.17293.47596.stgit@ltc189.sdl.hitachi.co.jp>
	 <1345642893.5069.31.camel@gandalf.local.home>
	 <50358F13.1030607@hitachi.com> <50359CE9.3000509@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 12:00 +0900, Masami Hiramatsu wrote:
> (2012/08/23 11:01), Masami Hiramatsu wrote:
> > (2012/08/22 22:41), Steven Rostedt wrote:
> >> On Wed, 2012-08-22 at 17:43 +0900, Yoshihiro YUNOMAE wrote:
> >>> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> >>>
> >>> Count debugfs/tracing/per_cpu/cpu* to determine the
> >>> number of CPUs.
> >>
> >> I'm curious, do you find that sysconf doesn't return the # of CPUs the
> >> system has?
> > 
> > No, sysconf returns the number of hosts CPUs, not guests.
> > 
> >> I've had boxes where the per_cpu/cpu* had more cpus than the
> >> box actually holds. But this was a bug in the kernel, not the tool. This
> >> change log needs to have rational instead of just explaining what the
> >> patch does.
> > 
> > Ah, I see. Hmm, then this should be enabled by a command line
> > option or an environment variable.
> 
> Oops, I misunderstood. I'll add more comment for why this
> should be tried instead of sysconf.

And now that I understand why you are doing this, why not only do this
if the TRACE_AGENT or DEBUG_TRACING_DIR is defined. That is, if we are
doing it against a bare metal system, then sysconf should suffice, but
if we are tracing against a guest, then it should use the tracing
directory to determine the buffers.

We could add options to override this, but I would think the default
should just Do The Right Thing(tm).

-- Steve


