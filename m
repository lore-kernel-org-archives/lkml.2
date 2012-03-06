Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2CFPiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:38:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43739 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2CFPir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:38:47 -0500
Message-ID: <1331048298.11248.320.camel@twins>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Date: Tue, 06 Mar 2012 16:38:18 +0100
In-Reply-To: <CACvQF53k9TQfPnVYA3DPeQbwqiA+4+Q5SqQ2dJSFQFAVmodD3Q@mail.gmail.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	 <1331031498.11248.273.camel@twins>
	 <CACvQF53k9TQfPnVYA3DPeQbwqiA+4+Q5SqQ2dJSFQFAVmodD3Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 23:17 +0800, Lai Jiangshan wrote:
> On Tue, Mar 6, 2012 at 6:58 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
> >>  /*
> >> + * 'return left < right;' but handle the overflow issues.
> >> + * The same as 'return (long)(right - left) > 0;' but it cares more.
> >
> > About what? And why? We do the (long)(a - b) thing all over the kernel,
> > why would you care more?
> 
> @left is constants of  the callers(callbacks's snapshot), @right
> increases very slow.
> if (long)(right - left) is a big negative, we have to wait for a long
> time in this kinds of overflow.
> this kinds of overflow can not happen in this safe_less_than()

I'm afraid I'm being particularly dense, but what?!
