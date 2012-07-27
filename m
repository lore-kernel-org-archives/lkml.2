Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2G0Q6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:58:37 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38848 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2G0Q6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:58:36 -0400
Date: Fri, 27 Jul 2012 18:58:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
Message-ID: <20120727165824.GN1173@somewhere.redhat.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
 <20120727164054.GJ2442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727164054.GJ2442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 09:40:54AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 27, 2012 at 05:40:30PM +0200, Frederic Weisbecker wrote:
> > Create a new subsystem that handles the hooks on kernel/user
> > boundaries currently used by RCU for its userspace extended
> > quiescent state.
> > 
> > We need to pull this up from RCU into this new level of indirection
> > because these hooks are also going to be used to implement an "on
> > demand" generic virtual cputime accounting. A necessary step to
> > shutdown the tick while still accounting the cputime.
> 
> So this eliminates the case where the architecture might enter an
> RCU extended quiescent state multiple times, but exit it only once?
> (I am hoping that it does...)

Yeah. It should handle that.
