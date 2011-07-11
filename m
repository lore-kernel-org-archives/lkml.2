Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab1GKQDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:03:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64653 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969Ab1GKQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:03:37 -0400
Date: Mon, 11 Jul 2011 18:03:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/6] Check for use of RCU from dyntick-idle
 mode
Message-ID: <20110711160330.GC4109@somewhere.redhat.com>
References: <20110708154331.GA20161@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708154331.GA20161@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 08:43:31AM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This set of patches adds checks for use of RCU from "extended quiescent
> states" such as dyntick-idle mode.  Such use is grossly illegal because
> RCU by definition ignores CPUs that are in extended quiescent states.
> In the case of dyntick-idle mode, the only way for RCU to avoid ignoring
> such CPUs would be to wake them up periodically, which would defeat the
> whole purpose of dyntick-idle mode.
> 
> The good news is that Frederic got this effort started.  The bad news is
> that there are several cases where RCU read-side critical sections appear
> in dyntick-idle mode.

Ok, let me send to you the patch that splits up rcu/tickless logic and I'll try
to fix up what you reported to me in ppc.

BTW, are you aware of other cases? You mentioned "several" :)
