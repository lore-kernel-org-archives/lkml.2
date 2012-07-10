Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2GJJSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:18:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35074 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab2GJJSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:18:47 -0400
Date: Tue, 10 Jul 2012 11:18:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] x86: Exit RCU extended QS on notify resume
Message-ID: <20120710091836.GF8185@somewhere.redhat.com>
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
 <1341576018-10721-7-git-send-email-fweisbec@gmail.com>
 <20120706163338.GW2522@linux.vnet.ibm.com>
 <20120706204329.GA9163@leaf>
 <20120708211707.GG2522@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120708211707.GG2522@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 02:17:07PM -0700, Paul E. McKenney wrote:
> On Fri, Jul 06, 2012 at 01:43:29PM -0700, Josh Triplett wrote:
> > On Fri, Jul 06, 2012 at 09:33:38AM -0700, Paul E. McKenney wrote:
> > > On Fri, Jul 06, 2012 at 02:00:18PM +0200, Frederic Weisbecker wrote:
> > > > --- a/arch/x86/Kconfig
> > > > +++ b/arch/x86/Kconfig
> > > > @@ -95,6 +95,7 @@ config X86
> > > >  	select KTIME_SCALAR if X86_32
> > > >  	select GENERIC_STRNCPY_FROM_USER
> > > >  	select GENERIC_STRNLEN_USER
> > > > +	select HAVE_RCU_USER_QS if X86_64
> > > 
> > > And I will bite yet again.  Why only 64-bit kernels?
> > 
> > Because HAVE_RCU_USER_QS requires an architecture-specific component,
> > and this patch series only added the necessary bits to entry_64.S.
> 
> OK, please allow me to rephrase the question.  Why only entry_64.S?  ;-)

So like I said, I prefer to wait for reviews and general opinion before
pushing further.
