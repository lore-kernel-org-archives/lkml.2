Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab0KQNcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:32:15 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44486 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab0KQNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:32:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=UZbAJZHdmKZ/YhaX40XsHSNV8g8gfWP/yHwV23gEVaqKYZL+FmrzGmhPmfFPA7YoYy
         nVqeCYKUVPoRAPA+rjqvd5wvn11/Uc+lVgTXJGVZ2Pc2EvHbYx7CoRIKz041bDIVhy2m
         2HqIshHntAywquhtz4YbMrVl1HhmXbs0JEuyw=
Date: Wed, 17 Nov 2010 14:32:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117133206.GE5464@nowhere>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <20101117144758.38bf4f05@deb0>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101117144758.38bf4f05@deb0>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please keep the initial Cc list)


On Wed, Nov 17, 2010 at 02:47:58PM +0200, Török Edwin wrote:
> I see --call-graph in the trace record -h output, but it doesn't seem to work on x86_64 for me.
> Do I need to pass some additional parameters to trace report, do I need additional CONFIG_ turned on?
> I have:
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> # CONFIG_CC_STACKPROTECTOR is not set
> CONFIG_STACKTRACE=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> # CONFIG_STACK_TRACER is not set
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> 
> Does it use the same code for callgraphs as ftrace, so I could choose userspace stacktrace?


So, this option comes from the fact this new tools wraps on perf record
command line. So yeah, your callchains are recorded, they are just not
reported by this new tool (yet).

Only perf report know how to deal with them for now.

You can play with that though, recording with "trace record -g" and look
at the result with "perf report", you'll get nice stats about your
callchains.

Now the tracing has yet to make use of it.

Ah and it doesn't use the same code than ftrace, but perf does kernel and
user callchain snapshot too. "-g" just record both.

