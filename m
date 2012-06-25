Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab2FYEDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 00:03:01 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59766 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2FYEDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 00:03:00 -0400
Date: Sun, 24 Jun 2012 21:02:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 07/17] key: Remove extraneous parentheses
 from rcu_assign_keypointer()
Message-ID: <20120625040250.GA11575@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1340379312-6684-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <29983.1340381076@redhat.com>
 <20120623055932.GF2516@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623055932.GF2516@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062504-7606-0000-0000-000001725FE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 10:59:32PM -0700, Paul E. McKenney wrote:
> On Fri, Jun 22, 2012 at 05:04:36PM +0100, David Howells wrote:
> > Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > This commit removes the extraneous parentheses from rcu_assign_keypointer()
> > > so that rcu_assign_pointer() can be wrapped in do-while.
> > 
> > Should it be wrapped in a do-while itself then?
> > 
> > And whilst you're at it, could you wrap PAYLOAD in parentheses?
> 
> Will do!

Before I forget again...  Is this what you had in mind?

							Thanx, Paul

------------------------------------------------------------------------

key: Remove extraneous parentheses from rcu_assign_keypointer()

This commit removes the extraneous parentheses from rcu_assign_keypointer()
so that rcu_assign_pointer() can be wrapped in do-while.  It also wraps
rcu_assign_keypointer() in a do-while and parenthesizes its final argument,
as suggested by David Howells.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

diff --git a/include/linux/key.h b/include/linux/key.h
index 4cd22ed..e3dbc54 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -303,7 +303,9 @@ static inline bool key_is_instantiated(const struct key *key)
 				   rwsem_is_locked(&((struct key *)(KEY))->sem)))
 
 #define rcu_assign_keypointer(KEY, PAYLOAD)				\
-	(rcu_assign_pointer((KEY)->payload.rcudata, PAYLOAD))
+do {									\
+	rcu_assign_pointer((KEY)->payload.rcudata, (PAYLOAD))		\
+while (0)
 
 #ifdef CONFIG_SYSCTL
 extern ctl_table key_sysctls[];

