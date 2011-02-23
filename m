Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1BWDXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:23:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43518 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1BWDXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:23:37 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=jNfASM90n5oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=5Qxpq5KOVw4_Z7Jd1pAA:9 a=GuYZ4DUI6UhbekDiIaWXpJajX_IA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC tip/core/rcu 05/11] rcu: add comment saying why
 DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT.
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
In-Reply-To: <1298425183-21265-5-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-5-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Feb 2011 22:23:29 -0500
Message-ID: <1298431409.7666.76.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 17:39 -0800, Paul E. McKenney wrote:
> The build will break if you change the Kconfig to allow
> DEBUG_OBJECTS_RCU_HEAD and !PREEMPT, so document the reasoning
> near where the breakage would occur.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcupdate.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index afd21d1..f3240e9 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -214,6 +214,11 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
>  		 * Ensure that queued callbacks are all executed.
>  		 * If we detect that we are nested in a RCU read-side critical
>  		 * section, we should simply fail, otherwise we would deadlock.
> +		 * Note that the machinery to reliably determine whether
> +		 * or not we are in an RCU read-side critical section
> +		 * exists only in the preemptible RCU implementations
> +		 * (TINY_PREEMPT_RCU and TREE_PREEMPT_RCU), which is why
> +		 * DEBUG_OBJECTS_RCU_HEAD is disallowed if !PREEMPT.
>  		 */

Shouldn't this comment also be in the kconfig where
DEBUG_OBJECTS_RCU_HEAD is defined?

-- Steve

>  		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
>  		    irqs_disabled()) {


