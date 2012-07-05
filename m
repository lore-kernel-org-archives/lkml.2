Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab2GEXCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:02:25 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57439 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab2GEXCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:02:24 -0400
X-Originating-IP: 217.70.178.145
X-Originating-IP: 50.43.46.74
Date: Thu, 5 Jul 2012 16:02:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu] Make RCU_FAST_NO_HZ respect nohz= boot
 parameter
Message-ID: <20120705230208.GB26150@leaf>
References: <20120705223731.GA27608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705223731.GA27608@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 03:37:31PM -0700, Paul E. McKenney wrote:
> If the nohz= boot parameter disables nohz, then RCU_FAST_NO_HZ needs to
> also disable itself.  This commit therefore checks for tick_nohz_enabled
> being zero, disabling rcu_prepare_for_idle() if so.  This patch assumes
> that tick_nohz_enabled can change at runtime: If this is not the case,
> then a simpler approach suffices.

Allowing nohz to change at runtime seems like an entirely unnecessary
bit of added complexity.  (So does having a boot parameter for it, but
that one at least seems easier to handle.)

What would the patch look like if you can assume nohz will never change
at runtime?  And does anyone have a use case for changing nohz at
runtime, rather than at boot time?

- Josh Triplett
