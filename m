Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1FIDpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:45:33 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43226 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab1FIDpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:45:33 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Wed, 8 Jun 2011 20:45:07 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 03/28] rcu: Streamline code produced by
 __rcu_read_unlock()
Message-ID: <20110609034507.GC6167@leaf>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
 <1307561407-13809-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307561407-13809-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 12:29:42PM -0700, Paul E. McKenney wrote:
> Given some common flag combinations, particularly -Os, gcc will inline
> rcu_read_unlock_special() despite its being in an unlikely() clause.
> Use noline to prohibit this misoptimization.

If rcu_read_unlock_special only gets called in the one place, why does
it hurt to inline it, as long as the inlined code stays on the cold
path?  Might as well remove the overhead of the function call.

- Josh Triplett
