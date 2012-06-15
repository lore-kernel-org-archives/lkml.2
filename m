Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab2FOUua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:50:30 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46046 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2FOUu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:50:29 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 13:50:12 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 06/14] rcu: Remove return value from
 RCU_INIT_POINTER()
Message-ID: <20120615205012.GJ31184@leaf>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339791195-26389-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339791195-26389-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 01:13:07PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The return value from RCU_INIT_POINTER() is not used, and using it
> would be quite ugly, for example:
> 
> 	q = RCU_INIT_POINTER(global_p, p);
> 
> To prevent this sort of ugliness from appearing, this commit wraps
> RCU_INIT_POINTER() in a do-while loop.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/rcupdate.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index eb92c21..f2cca02 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -904,7 +904,9 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>   * the reader-accessible portions of the linked structure.
>   */
>  #define RCU_INIT_POINTER(p, v) \
> -		p = (typeof(*v) __force __rcu *)(v)
> +	do { \
> +		p = (typeof(*v) __force __rcu *)(v); \
> +	} while (0)
>  
>  /**
>   * INIT_RCU_POINTER() - statically initialize an RCU protected pointer
> -- 
> 1.7.8
> 
