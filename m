Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2CLSN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:13:28 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38990 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2CLSN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:13:27 -0400
Date: Mon, 12 Mar 2012 10:52:21 -0700
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
Message-ID: <20120312175220.GE2471@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
 <1331031498.11248.273.camel@twins>
 <CACvQF53k9TQfPnVYA3DPeQbwqiA+4+Q5SqQ2dJSFQFAVmodD3Q@mail.gmail.com>
 <1331048298.11248.320.camel@twins>
 <20120308194905.GB2412@linux.vnet.ibm.com>
 <1331374349.18960.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331374349.18960.15.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031218-7408-0000-0000-00000362CDAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 11:12:29AM +0100, Peter Zijlstra wrote:
> On Thu, 2012-03-08 at 11:49 -0800, Paul E. McKenney wrote:
> > 
> > I too have used (long)(a - b) for a long time, but I saw with my own eyes
> > the glee in the compiler-writers' eyes when they discussed signed overflow
> > being undefined in the C standard.  I believe that the reasons for signed
> > overflow being undefined are long obsolete, but better safe than sorry. 
> 
> Thing is, if they break that the whole kernel comes falling down, I
> really wouldn't worry about RCU at that point. But to each their
> pet-paranoia I guess ;-)

But just because I am paranoid doesn't mean that no one is after me!  ;-)

I agree that the compiler guys would need to provide a chicken switch
due to the huge amount of code that relies on (long)(a - b) handling
overflow reasonably.  But avoiding signed integer overflow is pretty
straightforward.  For example, I use the following in RCU:

	#define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
	#define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
	#define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
	#define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))

But yes, part of the reason for my doing this was to make conversations
with the usual standards-committee suspects go more smoothly.

							Thanx, Paul

