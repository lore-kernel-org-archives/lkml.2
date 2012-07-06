Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2GFUns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:43:48 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60654 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2GFUnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:43:47 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.46.74
Date: Fri, 6 Jul 2012 13:43:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20120706204329.GA9163@leaf>
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
 <1341576018-10721-7-git-send-email-fweisbec@gmail.com>
 <20120706163338.GW2522@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706163338.GW2522@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 09:33:38AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 06, 2012 at 02:00:18PM +0200, Frederic Weisbecker wrote:
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -95,6 +95,7 @@ config X86
> >  	select KTIME_SCALAR if X86_32
> >  	select GENERIC_STRNCPY_FROM_USER
> >  	select GENERIC_STRNLEN_USER
> > +	select HAVE_RCU_USER_QS if X86_64
> 
> And I will bite yet again.  Why only 64-bit kernels?

Because HAVE_RCU_USER_QS requires an architecture-specific component,
and this patch series only added the necessary bits to entry_64.S.

- Josh Triplett
