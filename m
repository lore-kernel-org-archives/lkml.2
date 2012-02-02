Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2BBBO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:14:58 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:34775 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2BBBO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:14:56 -0500
Date: Wed, 1 Feb 2012 17:14:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC idle] Make arm, sh, and x86 stop using RCU when idle
Message-ID: <20120202011447.GS2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120202004253.GA10946@linux.vnet.ibm.com>
 <20120202004828.GC29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202004828.GC29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020201-7408-0000-0000-0000025578A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:48:29PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 04:42:53PM -0800, Paul E. McKenney wrote:
> > RCU's shiny new diagnostics (thank you, Frederic!) for using RCU when idle
> > located a few problems in arm, sh, and x86.  This patch series contains
> > alleged fixes for these problems.  And they are real problems -- if RCU
> > believes that the CPU is idle, it is ignoring it.  Which means that the
> > idle CPU can say "rcu_read_lock()" all it like, but there will be no
> > useful effect.
> 
> Having to put these calls down in every idle driver seems like such an
> ugly layering violation.  Not that I have a better alternative to
> suggest...

If you do happen to think of one, I would very much like to hear of it!  ;-)

							Thanx, Paul

