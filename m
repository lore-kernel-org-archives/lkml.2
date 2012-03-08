Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2CIQAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:00:16 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36364 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964877Ab2CIP7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:59:32 -0500
Date: Thu, 8 Mar 2012 11:49:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <eag0628@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
Message-ID: <20120308194905.GB2412@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
 <1331031498.11248.273.camel@twins>
 <CACvQF53k9TQfPnVYA3DPeQbwqiA+4+Q5SqQ2dJSFQFAVmodD3Q@mail.gmail.com>
 <1331048298.11248.320.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331048298.11248.320.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030915-7182-0000-0000-0000010115B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 04:38:18PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-03-06 at 23:17 +0800, Lai Jiangshan wrote:
> > On Tue, Mar 6, 2012 at 6:58 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
> > >>  /*
> > >> + * 'return left < right;' but handle the overflow issues.
> > >> + * The same as 'return (long)(right - left) > 0;' but it cares more.
> > >
> > > About what? And why? We do the (long)(a - b) thing all over the kernel,
> > > why would you care more?
> > 
> > @left is constants of  the callers(callbacks's snapshot), @right
> > increases very slow.
> > if (long)(right - left) is a big negative, we have to wait for a long
> > time in this kinds of overflow.
> > this kinds of overflow can not happen in this safe_less_than()
> 
> I'm afraid I'm being particularly dense, but what?!

I have been converting the "(long)(a - b)" stuff in RCU to use unsigned
arithmetic.  The ULONG_CMP_GE() and friends in rcupdate.h are for this
purpose.

I too have used (long)(a - b) for a long time, but I saw with my own eyes
the glee in the compiler-writers' eyes when they discussed signed overflow
being undefined in the C standard.  I believe that the reasons for signed
overflow being undefined are long obsolete, but better safe than sorry.

							Thanx, Paul

