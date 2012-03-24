Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2CXEtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 00:49:05 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37123 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2CXEtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 00:49:02 -0400
Date: Fri, 23 Mar 2012 21:48:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.4
Message-ID: <20120324044830.GF2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120320033300.GH2393@linux.vnet.ibm.com>
 <CA+55aFzXAdNRqNHm3-wx02au4b_Ze_WM-gCtOk+gJdGMsn3Zbg@mail.gmail.com>
 <20120323192143.GY2450@linux.vnet.ibm.com>
 <CA+55aFzgno-7AcHxKMWGYrr2QAwEzXOieSghnsEfPQJ5aed-yQ@mail.gmail.com>
 <20120323211638.GA2450@linux.vnet.ibm.com>
 <20120323212550.GA11791@linux.vnet.ibm.com>
 <20120324014755.GA4685@linux.vnet.ibm.com>
 <CA+55aFwgnhhoV=9PT3N0YToEwKDUB6pqOQhX3+6o3CeccC10=g@mail.gmail.com>
 <20120324041752.GE2450@linux.vnet.ibm.com>
 <CA+55aFxRJ+=j91vhZdDu0har8qvhLeP4fea_cSXzkaRE84wvvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxRJ+=j91vhZdDu0har8qvhLeP4fea_cSXzkaRE84wvvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032404-3270-0000-0000-0000050805F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 09:25:04PM -0700, Linus Torvalds wrote:
> On Fri, Mar 23, 2012 at 9:17 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > I must admit that __this_cpu_inc() would be nicer than __this_cpu_add(),
> > though, will fix.  I need the leading "__" to avoid disabling preemption
> > needlessly on non-x86 platforms.
> 
> Yeah, that's just bogus. Ok on that.
> 
> > The reason that the "__raw" forms are
> > safe in this case is because the per-CPU variable is saved and restored
> > at context-switch time.
> >
> > Or am I still missing something here?
> 
> It's not that the "__raw" forms are "safe". It's that they are SH*T.
> 
> Don't use them. They are crap. Why would you do
> 
> +       __raw_get_cpu_var(rcu_read_lock_nesting) =
> +               current->rcu_read_lock_nesting_save;
> 
> which is just crazy and cannot use the actual sane "%fs:" segment
> overrides, but instead has to do idiotic "ready the per-cpu offset
> pointer and add it in".
> 
>  We've got "__this_cpu_write()" which generates the correct code.
> 
> Rule of thumb: there is _never_ any good reason to use
> __raw_get_cpu_var. It's a broken interface.

OK, I will switch to __this_cpu_write(), thank you for the tip.

							Thanx, Paul

