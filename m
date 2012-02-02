Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2BBEzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 23:55:52 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51380 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2BBEzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 23:55:50 -0500
Date: Wed, 1 Feb 2012 20:55:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>, linux-pm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH RFC idle 1/3] x86: Avoid invoking RCU when CPU is idle
Message-ID: <20120202045538.GF2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120202004253.GA10946@linux.vnet.ibm.com>
 <1328143404-11038-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202015428.GA8807@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202015428.GA8807@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020204-4242-0000-0000-000000AB5E91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 02:54:30AM +0100, Frederic Weisbecker wrote:
> On Wed, Feb 01, 2012 at 04:43:22PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The idle loop is a quiscent state for RCU, which means that RCU ignores
> > CPUs that have told RCU that they are idle via rcu_idle_enter().  There
> > are nevertheless quite a few places where idle CPUs use RCU, most commonly
> > indirectly via tracing.  This patch fixes these problems for x86.
> > 
> > Many of these bugs have been in the kernel for quite some time, but
> > Frederic's recent change now gives warnings.
> > 
> > This patch takes the straightforward approach of pushing the
> > rcu_idle_enter()/rcu_idle_exit() pair further down into the core
> > of the idle loop.
> 
> I guess this is about the trace_power_*() things, right?

Indeed it is!  Alternative suggestions gladly accepted.  ;-)

							Thanx, Paul

> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Thanks.
> 

